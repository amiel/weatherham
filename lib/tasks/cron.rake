desc "Run cron tasks"
task :cron => :gather

task :gather => :environment do
	Gather.bellingham_coldstorage_observations!
end

