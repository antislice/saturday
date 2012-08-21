namespace :db do
	desc "sample games"
	task populate: :environment do
		Game.create!(home: false,
								 opponent: "Nebraska",
								 kickoff: Date.today.next_day(6))
 		Game.create!(home: true,
								 opponent: "Colorado",
								 kickoff: Date.today.next_day(10))
 		Game.create!(home: false,
								 opponent: "Iowa",
								 kickoff: Date.today.next_day(16))
 	end
end
