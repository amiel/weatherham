require 'time'
require 'open-uri'
class BellinghamColdstorage
  # these methods are poorly named, as this entire class is very specific to BCS
  # but it reads very nicely in the cron file :)
  def self.gather!
    new.gather!
  end

  # TODO, double check robustness
  def gather!
    @observations = get_datas!
    @last_observation_at = Observation.select(:observed_at).last.try(:observed_at)
    collection = @last_observation_at.nil? ? @observations : only_the_ones_we_care_about
    collection.each do |observation|
      o = Observation.create observation
      Observation.logger.info "created #{o.inspect}"
    end
  end

  # binary search, this is entirely unnecessary, but I just wanted to write a binary search
  # def only_the_ones_we_care_about(left = 0, right = @observations.size)
  #   pos = ((right - left) / 2) + left
  #   if @last_observation_at == @observations[left][:observed_at] then
  #     @observations[(left+1)..-1]
  #   elsif @observations[pos][:observed_at] <= @last_observation_at then
  #     only_the_ones_we_care_about pos, right
  #   else
  #     only_the_ones_we_care_about left, pos
  #   end
  # end

  def only_the_ones_we_care_about
    @observations.shift while @observations.first[:observed_at] <= @last_observation_at
    return @observations
  end

        # next unless datas
        # tolerance_range = (datas[:observed_at] - 1.minute)..(datas[:observed_at] + 1.minute)
        # next if Observation.first :conditions => { :observed_at => tolerance_range }
        # o = Observation.create datas
        # Observation.logger.info "created #{o.inspect}"


  def get_datas!
    [].tap do |datas|
      # http://www.bellcold.com/weather-history/history_2010.txt
      # http://www.bellcold.com/download.txt
      open 'http://www.bellcold.com/download.txt' do |f|
        f.each { |line| datas << self.class.parse_weather(line) }
      end
      datas.compact!
    end
  end

  def self.parse_weather line
    data = line.split
    return nil unless data[0].match %r{^\d{1,2}/\d{2}/\d{2}$}


    hash = Hash.new

    time = begin
      m = data[0].match %r{^(\d{1,2})/(\d{2})/(\d{2})$}
      Time.zone.parse(
        "20#{m[3]}-#{m[1]}-#{m[2]} #{data[1]}m"
        # the "m" turns 'p' into 'pm' and 'a' into 'am'
      )
    rescue ArgumentError, TypeError => e
      return nil
    end
    return nil if time.nil?

    hash[:observed_at] = time

    hash[:temp] = data[2]
    hash[:humidity] = data[5]
    hash[:dew_point] = data[6]
    hash[:wind_speed] = data[7]
    hash[:wind_dir] = data[8]
    hash[:wind_run] = data[9]
    hash[:hi_speed] = data[10]
    hash[:hi_dir] = data[11]
    hash[:wind_chill] = data[12]
    hash[:barometer] = data[15]
    hash[:rain] = data[17]

    return hash
  end
end

