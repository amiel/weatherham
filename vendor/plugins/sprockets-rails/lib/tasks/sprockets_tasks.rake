namespace :sprockets do
	desc "Generate and install the Sprockets concatenated JavaScript files from app/javascripts"
	task :install_scripts => :environment do
	  SprocketsApplication.use_google_closure_compiler = true
		asset_root = File.join(Rails.root, 'public', 'sprockets')
		Dir.mkdir asset_root unless File.exists? asset_root
		app_dir = File.join(Rails.root, 'app', 'javascripts')

		Dir[File.join(app_dir,'*.js')].each do |path|
			filename = File.basename path
			asset_path = File.join(asset_root, filename)
			s = SprocketsApplication.new(filename)
			puts "concatenation for #{filename} save_to(#{asset_path})"
      File.open(asset_path, "w") { |file| file.write(s.source) }
		end
	end
end