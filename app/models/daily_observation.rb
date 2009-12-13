class DailyObservation < ActiveRecord::Base
  include ObservationMixin
  period 1.day
  zoom 1.year
end
