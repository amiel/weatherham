class HourlyObservation < ActiveRecord::Base
  include ObservationMixin
  period 1.hour
  zoom 1.day
  
end
