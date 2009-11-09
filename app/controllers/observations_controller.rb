class ObservationsController < ApplicationController
	def index
		@observations = if params[:range] then
			range = Time.zone.parse(params[:range][:begin]) .. Time.zone.parse(params[:range][:end])
			logger.debug(range.inspect)
			Observation.all :conditions => { :observed_at => range }, :order => 'id DESC'
		else
			Observation.paginate :page => params[:page], :per_page => 500, :order => 'id DESC'
		end

		Fetch.start! if Observation.need_fetch?
		
		# logger.debug @observations.inspect
	end
end
