class Time
  def self.from_json(js_timestamp)
    Time.zone.at(js_timestamp.to_i / 1000)
  end
end
