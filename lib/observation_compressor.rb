class ObservationCompressor
  CLASSES = [ Observation, HourlyObservation ]
  extend MapReduceMethods
  
  REDUCE_METHODS = map_reduce_methods do
    wind_speed  round(avg, 1)
    hi_speed    max  
    temp        round(avg, 1)
    humidity    round(avg, 1)
    dew_point   round(avg, 2)
    wind_dir    first
    hi_dir      first
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
    latest_compressed = to.observed_at :first
    @start = latest_compressed.nil? ? from.observed_at(:first) : latest_compressed + @from.period
  end
  
  def compress!
    a, b = @start, @start + @to.period - @from.period
    until b > @from.observed_at(:last)
      compressed = @from.first :conditions => { :observed_at => [a,b] }, :select => REDUCE_METHODS.values.join(', ')
      @to.create! compressed.attributes.merge(:observed_at => a)
      
      a, b = a + @to.period, b + @to.period
    end
    return self
  end
  
  def prune!
    # TODO delete old @from
    return self
  end
  
end
