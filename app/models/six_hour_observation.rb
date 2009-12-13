class SixHourObservation < ActiveRecord::Base
  include ObservationMixin
  period 6.hours
  zoom 1.month
end
