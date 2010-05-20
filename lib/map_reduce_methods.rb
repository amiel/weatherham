module MapReduceMethods  
  def map_reduce_methods(&blk)
    c = Module.new

    c.mattr_accessor :mappings
    c.mappings = Hash.new

    def c.avg
      proc {|field| "avg(#{field})" }
    end

    def c.max
      proc {|field| "max(#{field})" }
    end

    def c.min
      proc {|field| "min(#{field})" }
    end

    def c.sum
      proc {|field| "sum(#{field})" }
    end

    def c.any
      proc {|field| "ANY(#{field})" }
    end

    def c.round(other_proc, precision)
      case ActiveRecord::Base.connection.adapter_name
        when 'PostgreSQL'
        proc { |field| "round(CAST (#{other_proc.call(field)} AS numeric), #{precision})" }
      else
        proc { |field| "round(#{other_proc.call(field)}, #{precision})" }
      end
    end

    def c.method_missing(method, arg)
      mappings[method] = arg.call(method) + " as #{method}"
    end

    c.instance_eval(&blk)
    return c.mappings
  end
end