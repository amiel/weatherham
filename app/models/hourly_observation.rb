class HourlyObservation < ActiveRecord::Base
  include ObservationMixin
  period 1.hour
  
end
