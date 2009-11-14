class ObservationsController < ApplicationController
	def index
		@observations = Observation.paginate :page => params[:page], :per_page => 5.days / 5.minutes, :order => 'id DESC'

		if Rails.env.production? and Observation.need_fetch? then
			Fetch.start!
			flash.now[:notice] = 'Gathering new datas!'
		end
	end
	
	def range
		range = Time.zone.parse(params[:range][:begin]) .. Time.zone.parse(params[:range][:end])
		logger.debug(range.inspect)
		@observations = Observation.all :conditions => { :observed_at => range }, :order => 'id DESC'
	end
end
