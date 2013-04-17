
require 'csv'



puts CSV.parse('12-outlook-schedule-mfootbl.csv', headers: true).to_json
