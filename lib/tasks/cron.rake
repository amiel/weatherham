desc "Run cron tasks"
task :cron => [ :gather, :compress ]

task :gather => :environment do
	Gather.bellingham_coldstorage_observations!
end

task :compress => :environment do
  # ObservationCompressor.run!
end

