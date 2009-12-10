module ObservationsHelper
  def plot name
    content_tag :div, '', :id => name, :style => 'width:940px;height:500px;', :class => 'flot'
  end

  def metric_toggler(name, options = {})
    options[:default] = true if options[:default].nil?
    options[:class] ||= ''
    options[:class] << (options[:default] ? " default_on" : " default_off")
    content_tag :div, check_box_with_label(name), :class => "metric_toggler #{options[:class]}"
  end

  def check_box_with_label(name)
    content_tag :label, check_box_tag(name) + t(:"attributes.#{name}.title", :default => name.titleize), :for => name
  end


  def attribute_pairs_for_plot(observations, attribute)
    observations.collect{|o| o.attribute_pair_for_plot(attribute) }
  end
  
  def data_for_plot
    returning data = Hash.new do
    	data[:plot_pairs] = Observation.displayed_attributes.each_with_object({}) do |attr, hash|
    		hash[attr] = attribute_pairs_for_plot(@observations, attr)
    	end

    	data[:times] = @observations.each_with_object({}) do |observation, hash|
    		hash[observation.observed_at_for_flot] = observation.attributes.reject{|k,v| ! Observation.other_attributes.values.include? k.to_sym }
    	end
    	
    	data[:mappings] = Observation.other_attributes
    	data[:earliest_point] = @observations.first.observed_at_for_flot
    	data[:latest_point] = @observations.last.observed_at_for_flot
  	end
  end
  
  def iphone_observation(field, options = {})
    content_tag(:li,
      content_tag(:span, options[:label] || t(:"attributes.#{field}.title"), :class => 'label') +
      content_tag(:small,
        @last_observation.send(field).to_s +
        content_tag(:span, options[:unit] || t(:"attributes.#{field}.unit"), :class => 'conter_label'),
      :class => 'counter')
    )
  end
  
  def direction_to_html(direction)
    case direction
    when :up   : '&uarr;'
    when :down : '&darr;'
    end
  end
end
