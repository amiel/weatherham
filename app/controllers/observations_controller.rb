class ObservationsController < ApplicationController
  GRANULARITIES = {
    five_min: Observation,
    # hourly: HourlyObservation,
    # six_hour: SixHourObservation,
    # daily: DailyObservation,
  }.with_indifferent_access.freeze


  def index
    Fetch.start! if Observation.first.nil?

    @last_observation = Observation.last
    @barometer_direction = Observation.current_barometer_direction if @last_observation
    @granularities = GRANULARITIES.keys
  end


  def show
    if Observation.need_fetch? && Rails.env.production?
      Rails.logger.critical("Needing a fetch now")
      Fetch.start!
    else
      Rails.logger.critical("No need for a fetch, just server up the db")
    end

    klass = GRANULARITIES[params[:id]]
    if stale?(fresh_options(klass.last))

      @ranges = {
        barometer: {
          max: klass.maximum(:barometer),
          min: klass.minimum(:barometer)
        },
        max: %w( hi_speed temp humidity ).collect{|a| klass.maximum a }.max
      }

      n = klass.zoom / klass.period
      @observations = klass.ordered.limit(n).offset([klass.count - n, 0].max).all
    end
  end

  def range
    klass = GRANULARITIES[params[:granularity]]
    range = Time.from_json(params[:range_begin]) .. Time.from_json(params[:range_end])
    if stale?(etag: Digest::SHA1.hexdigest("#{klass}/#{range}"))
      @observations = klass.where(observed_at: range).all
      render 'show'
    end
  end

  def statistics
    # {"observation":{"wind_dir":"SSE","temp":54.2,"low_temp":null,"hi_speed":27.0,"observed_at":"2010-04-27T11:10:00-07:00","humidity":71,"created_at":"2010-04-27T11:14:47-07:00","barometer":29.378,"updated_at":"2010-04-27T11:14:47-07:00","wind_chill":47.6,"wind_speed":16.0,"id":33531,"hi_dir":"SSE","wind_run":1.33,"hi_temp":null,"dew_point":45.0}}
    @statistics = Observation.statistics
    respond_to do |with|
      with.xml { render xml: @statistics }
      with.json { render json: @statistics }
    end
  end

end
