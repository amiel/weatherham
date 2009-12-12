class ObservationsController < ApplicationController
  COUNTS = {
    :five_min => 1.day / 5.minutes
  }.with_indifferent_access.freeze
  
  
  def index
    if Rails.env.production? and Observation.need_fetch? then
      Fetch.start!
      flash.now[:notice] = I18n.t(:gathering_new_datas)
    end
    
    return render(:inline => 'gathering datas') if Observation.first.nil?
    
		@ranges = {
			:barometer => {
				:max => Observation.maximum(:barometer),
				:min => Observation.minimum(:barometer)
			},
			:max => %w( hi_speed temp humidity ).collect{|a| Observation.maximum a }.max
		}
		
    @last_observation = Observation.last
    @barometer_direction = Observation.current_barometer_direction
  end


  
  def show
    if stale?(fresh_options(Observation.last)) then
      n = COUNTS[params[:id]]
      @observations = Observation.all :limit => n, :offset => (Observation.count - n)
    end
  end

  def range
    range = Time.from_json(params[:range_begin]) .. Time.from_json(params[:range_end])
    if stale?(:last_modified => range.first) then
      @observations = Observation.all :conditions => { :observed_at => range }
      render :action => 'show'
    end
  end

  def changelog
    @changelog ||= begin
      lines = File.readlines(File.join(Rails.root, 'CHANGELOG.textile'))
      RedCloth.new(lines.to_s).to_html
    end
    
    fresh_when(:etag => Digest::SHA1.hexdigest(@changelog), :public => true)
  end
  
  def todo
    @todo ||= begin
      lines = File.readlines(File.join(Rails.root, 'README.textile'))
      RedCloth.new(lines.to_s).to_html
    end
    
    fresh_when(:etag => Digest::SHA1.hexdigest(@todo), :public => true)
  end

end
