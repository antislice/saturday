desc 'updates the team calendar'
task :update_games => :environment do
  puts 'Updating games...'
  # retrieve .ics file from yahoo
  # save file
  Game.update_from_ics
  puts 'done.'
end