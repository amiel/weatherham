
namespace :heroku do
  desc "Commit pre-deployment changes"
  task :commit do
    puts 'Committing deployment changes'
    system "git add . && git commit -m 'Prepare for heroku deployment'"
  end

  task :commit_lack_of_assets do
    puts 'Committing deletion of assets'
    system "git commit -m'clean up assets after deploy'"
  end
end

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