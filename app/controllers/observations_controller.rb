class ObservationsController < ApplicationController
  COUNTS = {
    :five_min => 1.day / 5.minutes
  }.with_indifferent_access.freeze
  
  
  def index
		@ranges = {
			:barometer => {
				:max => Observation.maximum(:barometer),
				:min => Observation.minimum(:barometer)
			},
			:max => %w( hi_speed temp humidity ).collect{|a| Observation.maximum a }.max
		}
		
    if Rails.env.production? and Observation.need_fetch? then
      Fetch.start!
      flash.now[:notice] = 'Gathering new datas!'
    end
  end


  
  def show
    if stale?(fresh_options(Observation.last)) then
      n = COUNTS[params[:id]]
      @observations = Observation.all :limit => n, :offset => (Observation.count - n)
    end
  end

  def range
    range = Time.zone.parse(params[:range][:begin]) .. Time.zone.parse(params[:range][:end])
    logger.debug(range.inspect)
    @observations = Observation.all :conditions => { :observed_at => range }, :order => 'id DESC'
  end

  def changelog
    @changelog ||= begin
      lines = File.readlines(File.join(Rails.root, 'CHANGELOG.textile'))
      RedCloth.new(lines.to_s).to_html
    end
    
    cache_for 1.month
  end
end
