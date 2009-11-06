module SprocketsHelper
	def sprockets_include_tag(*names)
		if names.empty?
			javascript_include_tag("/sprockets.js")
		else
			javascript_include_tag(*names.collect{|n| "/sprockets/#{n}"})
		end
	end
end
