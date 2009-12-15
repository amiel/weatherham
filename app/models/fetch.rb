class Fetch < ActiveRecord::Base
  belongs_to :observation # the most recent observation at this fetch
  named_scope :unfinished, :conditions => { :finish_at => nil }
  named_scope :without_error, :conditions => { :error => false }


  def self.start!
    return if Fetch.unfinished.without_error.first # a fetch hasn't finished? return and let it do its thing
    create! # ie, call do_fetch
  end

  after_create :do_fetch
  def do_fetch
      self.start_at = Time.current
      self.save

      Gather.bellingham_coldstorage_observations!

      self.finish_at = Time.current
      self.observation = Observation.last
      self.save
  end
end
