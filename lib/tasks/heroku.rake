
namespace :assets do

    desc "Compiles and concatenates javascripts"
    task :compile => :'sprockets:install_scripts'

    desc "Remove compiled and concatenated assets"
    task :cleanup do
      Dir.glob("#{File.dirname(__FILE__)}/../../public/sprockets/*.js").each do |js|
        FileUtils.rm_rf(js)
        system "git rm #{js}"
      end
      puts 'Removed compiled javascripts'
    end

end