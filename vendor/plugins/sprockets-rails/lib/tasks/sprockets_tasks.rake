namespace :sprockets do
	desc "Generate and install the Sprockets concatenated JavaScript files from app/stylesheets"
	task :install_scripts => :environment do
		asset_root = File.join(Rails.root, 'public', 'sprockets')
		File.mkdir asset_root
		Dir.chdir File.join(Rails.root, 'app', 'stylesheets') do
			Dir['*.js'].each do |filename|
				asset_path = File.join(asset_root, filename)
				s = SprocketsApplication.new(filename)
				puts "concatenation for #{filename} save_to(#{asset_path})"
				s.concatenation.save_to(asset_path)
			end
		end
	end
end