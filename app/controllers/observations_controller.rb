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
end
