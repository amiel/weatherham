class ObservationsController < ApplicationController
	def index
		@observations = Observation.paginate :page => params[:page], :per_page => 100
	end
end
