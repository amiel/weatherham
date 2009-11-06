class ObservationsController < ApplicationController
	def index
		@observations = Observation.paginate :page => params[:page], :per_page => 10, :order => 'id DESC'
	end
end
