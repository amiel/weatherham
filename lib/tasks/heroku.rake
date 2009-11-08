namespace :heroku do

	desc "Prepare and deploy the application to heroku"
	task :deploy => ['heroku:deploy:default']

	namespace :deploy do

		task :default => ['assets:compile', :commit, :push, 'assets:cleanup']

		desc "Commit pre-deployment changes"
		task :commit do
			puts 'Committing deployment changes'
			if system 'git status' then # if there are changed files, then this is after assets:cleanup
				system "git commit -m'cleaned up assets after deploy'"
			else # we expect that the user called deploy with a clean working tree
				system "git add . && git commit -m 'Prepared for heroku deployment'"
			end
		end

		desc "Push application to heroku"
		task :push do
			puts 'Pushing application to heroku'
			system "git push heroku master"
		end

		desc "Prepare and deploy the application to heroku and run pending migrations"
		task :migrations => :default do
			puts 'Running pending migrations'
			system "heroku rake db:migrate"
		end

	end

end

namespace :assets do

	desc "Compiles and concatenates javascripts"
	task :compile => :'sprockets:install_scripts'

	desc "Minifies cached javascript and stylesheets"
	task :minify do

		require 'rubygems'
		require 'jsmin'
		require 'cssmin'

		Dir.glob("#{File.dirname(__FILE__)}/../../public/stylesheets/compiled/*.css").each do |css|
			f = ""
			File.open(css, 'r') {|file| f << CSSMin.minify(file)}
			File.open(css, 'w') {|file| file.write(f)}
			puts "Minified #{css}"
		end

		Dir.glob("#{File.dirname(__FILE__)}/../../public/sprockets.js").each do |js|
			f = ""
			File.open(js, 'r') {|file| f << JSMin.minify(file)}
			File.open(js, 'w') {|file| file.write(f)}
			puts "Minified #{js}"
		end

	end

	desc "Remove compiled and concatenated assets"
	task :cleanup do
		Dir.glob("#{File.dirname(__FILE__)}/../../public/sprockets/*.js").each do |js|
			FileUtils.rm_rf(js)
			system "git rm #{js}"
		end
		puts 'Removed compiled javascripts'
	end

end