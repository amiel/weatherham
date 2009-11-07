namespace :sprockets do
	desc "Generate and install the Sprockets concatenated JavaScript files from app/javascripts"
	task :install_scripts => :environment do
		asset_root = File.join(Rails.root, 'public', 'sprockets')
		Dir.mkdir asset_root unless File.exists? asset_root
		Dir.chdir File.join(Rails.root, 'app', 'javascripts') do
			p Dir['*']
			Dir['*.js'].each do |filename|
				asset_path = File.join(asset_root, filename)
				s = SprocketsApplication.new(filename)
				puts "concatenation for #{filename} save_to(#{asset_path})"
				s.send(:concatenation).save_to(asset_path)
			end
		end
	end
end