class Fetch < ActiveRecord::Base
  attr_accessible :error, :finish_at, :observation_id, :start_at

  belongs_to :observation # the most recent observation at this fetch
  scope :unfinished, where(finish_at: nil)
  scope :without_error, where(error: false)


  def self.start!
    first.destroy if count > 100

    # Return and let it do its thing if there is an unfinished fetch
    return if Fetch.unfinished.without_error.first

    create!.tap(&:do_fetch)
  end

  def do_fetch
    self.start_at = Time.current
    self.save

    BellinghamColdstorage.gather!

    self.finish_at = Time.current
    self.observation = Observation.last
    self.save
  end
end
