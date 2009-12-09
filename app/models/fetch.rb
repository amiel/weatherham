class Fetch < ActiveRecord::Base
  belongs_to :observation # the most recent observation at this fetch
  named_scope :unfinished, :conditions => { :finish_at => nil }
  named_scope :without_error, :conditions => { :error => false }


  def self.start!
    return if Fetch.unfinished.without_error.first # a fetch hasn't finished? return and let it do its thing
    create!
  end

  after_create :spawn_and_fetch
  def spawn_and_fetch
    logger.error('STARTING SPAWN')
    spawn do
      logger.error("SPAWN STARTED: #{Time.current}")
      self.update_attribute :start_at, Time.current

      Gather.bellingham_coldstorage_observations!

      self.finish_at = Time.current
      self.observation = Observation.last
      self.save
    end
  end
end
