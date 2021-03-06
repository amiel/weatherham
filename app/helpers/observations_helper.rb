module ObservationsHelper
  def plot(name)
    content_tag :div, '', id: name, class: 'flot'
  end

  def metric_toggler(name, icon_name, options = {})
    icon = icon(icon_name)
    options[:default] = true if options[:default].nil?
    options[:class] ||= ''
    options[:class] << ' ' + name.to_s
    options[:class] << (options[:default] ? " default_on" : " default_off")
    content_tag :div, check_box_with_label(name, icon), :class => "metric_toggler #{options[:class]}"
  end

  def check_box_with_label(name, icon)
    content_tag :label, icon + check_box_tag(name) + t(:"attributes.#{name}.title", :default => name.titleize), :for => name
  end

  def attribute_pairs_for_plot(observations, attribute)
    observations.collect{|o| o.attribute_pair_for_plot(attribute) }
  end

  def data_for_plot
    Hash.new.tap do |data|
      return nil if @observations.size.zero?

      data[:plot_pairs] = Observation.displayed_attributes.each_with_object({}) do |attr, hash|
        hash[attr] = attribute_pairs_for_plot(@observations, attr)
      end

      data[:times] = @observations.each_with_object({}) do |observation, hash|
        hash[observation.observed_at_for_flot] = observation.attributes.reject{|k,v| ! Observation.other_attributes.values.include? k.to_sym }
      end

      data[:mappings] = Observation.other_attributes
      data[:earliest_point] = @observations.first.observed_at_for_flot
      data[:latest_point] = @observations.last.observed_at_for_flot
      data[:yaxis_ranges] = @ranges
      p data.keys, data[:yaxis_ranges]
    end
  end

  # TODO: this appears to be unused
  def iphone_observation(field, options = {})
    content_tag(:li,
      content_tag(:span, options[:label] || t(:"attributes.#{field}.title"), :class => 'label') +
      content_tag(:small,
        @last_observation.send(field).to_s +
        content_tag(:span, options[:unit] || t(:"attributes.#{field}.unit"), :class => 'counter_label'),
      :class => 'counter')
    )
  end

  def direction_to_html(direction)
    @_direction_entities ||= {
      up: '&uarr;',
      down: '&darr;',
    }

    @_direction_entities.fetch(direction, '').html_safe
  end

  private

  def icon(name)
    content_tag :i, nil, class: "wi wi-#{name}"
  end
end
