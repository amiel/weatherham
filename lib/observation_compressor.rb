class ObservationCompressor
  CLASSES = [ Observation, HourlyObservation, SixHourObservation, DailyObservation ]
  PRUNE_TO = proc{|from,to| from.observed_at(:last) - (to.zoom * 2) }
  
  extend MapReduceMethods
  
  REDUCE_METHODS = map_reduce_methods do
    wind_speed  round(avg, 1)
    hi_speed    max
    temp        round(avg, 1)
    humidity    round(avg, 1)
    dew_point   round(avg, 2)
    wind_dir    any
    hi_dir      any
    wind_run    round(sum, 3)
    wind_chill  round(avg, 1)
    barometer   round(avg, 3)
  end

  
  def self.run!
    CLASSES.inject(nil) do |prev, this|
      new(prev, this).compress!.prune! unless prev.nil?
      next this
    end
  end
  
  def initialize(from, to)
    @from, @to = from, to
    latest_compressed = to.observed_at :last
    @start = latest_compressed.nil? ? from.observed_at(:first) : latest_compressed + @from.period
  end
  
  def compress!
    a, b = @start, @start + @to.period - @from.period
    until b > @from.observed_at(:last)
      compressed = @from.first :conditions => { :observed_at => [a,b] }, :select => REDUCE_METHODS.values.join(', ')
      compressed_attributes = compressed.attributes.merge(:observed_at => a)
      unless compressed.attributes.all?{|k,v| v.blank? }
        @to.create! compressed_attributes
      else
        @to.logger.error("didn't create compressed_attributes (#{compressed.inspect}) (#{@from.first(:conditions => { :observed_at => [a,b] }).inspect})")
      end
      
      a, b = a + @to.period, b + @to.period
    end
    return self # allow chaining
  end
  
  def prune!
    # @from.delete_all [ 'observed_at < ?', PRUNE_TO.call(@from,@to) ]
    return self # allow chaining
  end
  
end
