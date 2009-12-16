class ObservationsController < ApplicationController
  GRANULARITIES = {
    :five_min => Observation,
    :hourly => HourlyObservation,
    :six_hour => SixHourObservation,
    :daily => DailyObservation,
  }.with_indifferent_access.freeze
  
  
  def index
    if Rails.env.production? and Observation.need_fetch? then
      Fetch.start!
      flash.now[:notice] = I18n.t(:gathering_new_datas)
    end
    
    return render(:inline => 'gathering datas') if Observation.first.nil?
    
		@ranges = {
			:barometer => {
				:max => Observation.maximum(:barometer),
				:min => Observation.minimum(:barometer)
			},
			:max => %w( hi_speed temp humidity ).collect{|a| Observation.maximum a }.max
		}
		
    @last_observation = Observation.last
    @barometer_direction = Observation.current_barometer_direction
    @granularities = GRANULARITIES.keys
  end


  
  def show
    klass = GRANULARITIES[params[:id]]
    if stale?(fresh_options(klass.last)) then
      n = klass.zoom / klass.period
      @observations = klass.all :limit => n, :offset => ([klass.count - n, 0].max)
    end
  end

  def range
    klass = GRANULARITIES[params[:granularity]]
    range = Time.from_json(params[:range_begin]) .. Time.from_json(params[:range_end])
    if stale?(:etag => Digest::SHA1.hexdigest("#{klass}/#{range}")) then
      @observations = klass.all :conditions => { :observed_at => range }
      render :action => 'show'
    end
  end

  def changelog
    @changelog ||= begin
      lines = File.readlines(File.join(Rails.root, 'CHANGELOG.textile'))
      RedCloth.new(lines.to_s).to_html
    end
    
    fresh_when(:etag => Digest::SHA1.hexdigest(@changelog), :public => true)
  end
  
  def todo
    @todo ||= begin
      lines = File.readlines(File.join(Rails.root, 'README.textile'))
      RedCloth.new(lines.to_s).to_html
    end
    
    fresh_when(:etag => Digest::SHA1.hexdigest(@todo), :public => true)
  end

end
