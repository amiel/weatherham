module ObservationsHelper
  def plot name
    content_tag :div, '', :id => name, :style => 'width:940px;height:500px;', :class => 'flot grid_12'
  end

  def metric_toggler(name, options = {})
    options[:grid_size] ||= '2'
    options[:default] = true if options[:default].nil?
    options[:class] ||= ''
    options[:class] << (options[:default] ? " default_on" : " default_off")
    content_tag :div, check_box_with_label(name), :class => "grid_#{options[:grid_size]} metric_toggler #{options[:class]}"
  end

  def check_box_with_label(name)
    content_tag :label, check_box_tag(name) + t(:"datas.#{name}.title", :default => name.titleize), :for => name
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
    		hash[observation.observed_at_for_json] = observation.attributes.reject{|k,v| ! Observation.other_attributes.include? k }
    	end
  	end
  end
end
