class SprocketsApplication
	cattr_accessor :use_google_closure_compiler
	self.use_google_closure_compiler = Rails.env.production?

	def initialize(name = nil)
		@name = name.blank? ? nil : name
		@name = "#{@name}.js" unless @name && File.extname(@name) == '.js'
	end

	def source
		concatenation.to_s
	end

	protected
	def secretary
		@@secretary = {}
		@@secretary[@name] ||= Sprockets::Secretary.new(configuration.merge(:root => RAILS_ROOT))
	end
	
	def configuration
		returning conf = YAML.load(IO.read(File.join(RAILS_ROOT, "config", "sprockets.yml"))) || {} do
			if @name then
				dir = conf[:load_path].find{|d| !Dir[File.join(d,@name)].empty? }
				conf[:source_files] = [File.join(dir, @name)] if dir
			end
		end
	end

	def concatenation
		secretary.reset! unless source_is_unchanged?
		secretary.concatenation
	end
	
	def concatenation_with_google_closure_compiler
    GoogleClosureCompiler::Javascript.new(concatenation_without_google_closure_compiler).compiled
  end
  alias_method_chain :concatenation, :google_closure_compiler if use_google_closure_compiler and defined? GoogleClosureCompiler


	def source_is_unchanged?
		previous_source_last_modified, @source_last_modified = 
			@source_last_modified, secretary.source_last_modified

		previous_source_last_modified == @source_last_modified
	end

	class << self
		def routes(map)
			map.resources(:sprockets)
		end
		
    # blatently ripped from 'more'
		def use_page_caching?
      (not heroku?) && page_cache_enabled_in_environment_configuration?
		end

    # blatently ripped from 'more'		    
    def page_cache_enabled_in_environment_configuration?
      Rails.configuration.action_controller.perform_caching
    end
		
		# Returns true if the app is running on Heroku. When +heroku?+ is true,
    # +use_page_caching?+ will always be false.
    # blatently ripped from 'more'
    def heroku?
      !!ENV["HEROKU_ENV"]
    end
	end
end
