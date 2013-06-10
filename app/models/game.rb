require 'csv'

class Game < ActiveRecord::Base
  attr_accessible :home, :kickoff, :opponent, :location

  def self.update_schedule
    puts 'updating....'

    Game.destroy_all

# header names
    start_date = 'START DATE'
    start_time = 'START TIME'
    subject_str = 'SUBJECT'
    location_str = 'LOCATION'

    first_line = CSV.read('12-outlook-schedule-mfootbl.csv', headers: true).first.to_hash
    puts first_line

    g = Game.new(:kickoff => parse_kickoff(first_line[start_date], first_line[start_time]),
                 :home => at_home?(first_line[location_str]),
                 :opponent => parse_opponent(first_line[subject_str]),
                 :location  => first_line[location_str])
    g.save

    puts g.kickoff
    puts g.opponent
    puts g.location

  end

  private

  def self.parse_opponent(subject)
    subject.partition('vs.').last.strip.gsub(/[^0-9a-z ]/i, '')
  end

  def self.at_home?(location)
    location.downcase.include?('stanford')
  end

  def self.parse_kickoff(start_date, start_time)
    puts 'date ' << start_date
    puts 'time ' << start_time
    game_datetime_str = '' << start_date << ' ' << start_time.sub('PT', 'PST') #check on daylight savings
    dt = DateTime.strptime(game_datetime_str, '%m/%d/%Y %R %P %Z')
    puts dt
    dt
  end

end
