
require 'csv'

# header names
start_date = "START DATE"
start_time = "START TIME"
subject = "SUBJECT"
location = "LOCATION"

first_line = CSV.read('12-outlook-schedule-mfootbl.csv', headers: true).first.to_hash
puts first_line

puts first_line[subject]
puts first_line[location]









game_datetime_str = first_line[start_date] << ' ' << first_line[start_time].sub!('PT', 'PST')
game_datetime = DateTime.strptime(game_datetime_str, '%m/%d/%Y %R %P %Z')