module ObservationMixin
  def self.included(base)
    base.named_scope :only_id, :select => 'id'
    base.named_scope :only_time, :select => 'id, observed_at'
    base.validates_presence_of :observed_at
    base.extend ClassMethods
    
    if base != Observation then
      def base.displayed_attributes
        Observation.displayed_attributes
      end
      
      def base.other_attributes
        Observation.other_attributes
      end
    end
  end
  
  module ClassMethods
    def observed_at(where, options = {})
      only_time.send(where, options).try(:observed_at)
    end

    # class setter getters
    
    def period(p = nil)
      p.nil? ? @@period ||= nil : @@period = p
    end
    
    def zoom(t = nil)
      t.nil? ? @@zoom ||= nil : @@zoom = t
    end
  end
  
  
  def observed_at_for_flot
    observed_at.to_i * 1000
  end

  def attribute_pair_for_plot(attribute)
    [ self.observed_at_for_flot, self[attribute] ]
  end
end