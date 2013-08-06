require 'icalendar'
include Icalendar

class Game < ActiveRecord::Base
  attr_accessible :home, :kickoff, :opponent, :location

  def self.cal_update
    puts 'parsing calendar...'

    raw_file = File.open('single_event.ics').read
    puts raw_file

    raw_file.gsub!("TZID:America/Los_Angeles\n", '') # makes the file parse correctly
    # however, may need to insert a timezone section instead
    # or add the time zone by hand..  (all of them are in pacific at least)

    cal = Icalendar.parse(raw_file).first

    game = cal.events.first

    puts game.dtstamp.zone
    puts game.summary

  end

  def self.update_schedule
    puts 'updating....'

    Game.destroy_all

# header names
    start_date = 'START DATE'
    start_time = 'START TIME'
    subject_str = 'SUBJECT'
    location_str = 'LOCATION'

    CSV.read('12-outlook-schedule-mfootbl.csv', headers: true).each do |row|

      row_hash = row.to_hash

      g = Game.new(:kickoff => parse_kickoff(row_hash[start_date], row_hash[start_time]),
                   :home => at_home?(row_hash[location_str]),
                   :opponent => parse_opponent(row_hash[subject_str]),
                   :location  => row_hash[location_str])
      g.save!
      puts g.pretty_print
    end
    puts 'done, number of games: ' << Game.count
  end

  def pretty_print
    "Game #{id}: time - #{kickoff}, opponent - #{opponent}, location: #{location}"
  end

  private

  def self.parse_opponent(subject)
    subject.partition('vs.').last.strip.gsub(/[^0-9a-z ]/i, '')
  end

  def self.at_home?(location)
    location.downcase.include?('stanford')
  end

  def self.parse_kickoff(start_date, start_time)

    if start_time == 'TBA'
      return DateTime.strptime(start_date, '%m/%d/%Y')
    end

    game_datetime_str = '' << start_date << ' ' << start_time.sub('PT', 'PDT') #check on daylight savings
    if DateTime.strptime(game_datetime_str, '%m/%d/%Y %R %P').in_time_zone(Time.zone).dst?
      game_datetime_str.sub!('PT', 'PDT')
    else
      game_datetime_str.sub!('PT', 'PST')
    end
    DateTime.strptime(game_datetime_str, '%m/%d/%Y %R %P %Z').in_time_zone(Time.zone)
  end

end
