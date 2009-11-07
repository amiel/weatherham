module ObservationsHelper
	def plot name
		content_tag :div, '', :id => name, :style => 'width:460px;height:300px;', :class => 'flot grid_6'
	end
end
