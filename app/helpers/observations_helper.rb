module ObservationsHelper
	def plot name
		content_tag :div, '', :id => name, :style => 'width:940px;height:500px;', :class => 'flot grid_12'
	end
	
	def metric_toggler(name)
		content_tag :div, check_box_with_label(name), :class => 'grid_2 metric_toggler'
	end
	
	def check_box_with_label(name)
		content_tag :label, check_box_tag(name) + t(name, :default => name.titleize), :for => name
	end
end
