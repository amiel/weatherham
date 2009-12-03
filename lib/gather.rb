require 'time'
require 'open-uri'
module Gather
	def self.bellingham_coldstorage_observations!

		open 'http://www.bellcold.com/download.txt' do |f|
			f.each do |line|
				datas = parse_weather(line)
				next unless datas
				tolerance_range = (datas[:observed_at] - 1.minute)..(datas[:observed_at] + 1.minute)
				next if Observation.first :conditions => { :observed_at => tolerance_range }
				o = Observation.create datas
				Observation.logger.info "created #{o.inspect}"
			end
		end
	end


	def self.parse_weather line
		data = line.split
		return nil unless data[0].match %r{^\d{2}/\d{2}/\d{2}$}


		hash = Hash.new

		time = begin
			Time.zone.parse(
			data[0..1].join(' ') + # date and time
			'm' # turn 'p' into 'pm' and 'a' into 'am'
			)
		rescue ArgumentError, TypeError => e
			return nil
		end
		return nil if time.nil?

		hash[:observed_at] = time

		hash[:temp] = data[2]
		hash[:hi_temp] = data[3]
		hash[:low_temp] = data[4]
		hash[:humidity] = data[5]
		hash[:dew_point] = data[6]
		hash[:wind_speed] = data[7]
		hash[:wind_dir] = data[8]
		hash[:wind_run] = data[9]
		hash[:hi_speed] = data[10]
		hash[:hi_dir] = data[11]
		hash[:wind_chill] = data[12]
		hash[:barometer] = data[15]
    # hash[:rain] = data[16]

		return hash
	end
end

