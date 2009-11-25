

desc 'Push code to heroku'
task :deploy do
  puts 'setting up compiled assets'
  puts `rake assets:compile`
  puts `rake heroku:commit`
  
  puts 'Deploying site to Heroku ...'
  puts `git push -f heroku`
  
  release_name = "deploy-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
  puts "Tagging release as '#{release_name}'"
  puts `git tag -a #{release_name} -m 'Tagged release'`
  # puts `git push --tags heroku`
  
  puts `rake assets:cleanup`
  puts `rake heroku:commit_lack_of_assets`
  
  puts 'All done!'
end

desc 'rollback to the previous heroku deployed tag'
task :rollback do
  releases = `git tag`.split("\n").select { |t| t[0..6] == 'deploy-' }.sort
  current_release = releases.last
  previous_release = releases[-2] if releases.length >= 2
  if previous_release then
    puts "Rolling back to '#{previous_release}' ..."
    puts `git push -f heroku #{previous_release}:master`
    puts "Deleting rollbacked release '#{current_release}' ..."
    puts `git tag -d #{current_release}`
    puts `git push heroku :refs/tags/#{current_release}`
    puts 'All done!'
  else
    puts "No release tags found - can't roll back!"
    puts releases
  end
end

namespace :db do
  task :migrate do
    puts 'Running database migrations ...'
    puts `heroku rake db:migrate`
  end
end
