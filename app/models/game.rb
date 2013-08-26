require 'icalendar'
include Icalendar

class Game < ActiveRecord::Base
  attr_accessible :opponent, :location, :note, :game_date, :game_time

  def self.import_starter_data
    Game.destroy_all # this is essentially a reset of the db

    json = JSON.parse(File.open('games.json').read)
    json.each do |item|
      game = Game.create!(:opponent => item['opponent'],
                 :location => item['location'],
                 :note => item['note'])
      update_game_date_and_time(item['time'], item['date'], game)

      Rails.logger.debug game.pretty_print
      game.save!
    end

    Rails.logger.info "there are currently #{Game.count} games saved after importing starter data"

    # cal_update
  end

  def self.update_from_ics
    # TODO
    # change to look up yahoo calendar
    # map events by date? (match events by Date, update if Time is different?)
    # only update if something changed from TBD or time changed

    Rails.logger.debug 'parsing calendar...'

    raw_file = File.open('yahoo-calendar.ics').read
    cal = Icalendar.parse(raw_file).first

    cal.events.each do |game|
      puts game.summary << ' on ' << game.dtstart.in_time_zone(Time.zone).to_s
    end

  end

  def home
    location.downcase.include?('stanford')
  end

  def pretty_print
    "Game #{id}: date - #{game_date}, time - #{game_time}, opponent - #{opponent}, location: #{location}"
  end

  private

  def self.parse_opponent(subject)
    subject.partition('vs.').last.strip.gsub(/[^0-9a-z ]/i, '')
  end

  def self.update_game_date_and_time(start_time, start_date, game)

    if start_time == 'TBD'
      game.game_date = DateTime.strptime(start_date, '%m/%d/%y')
      game.game_time = nil
      return
    end

    game.game_date = game.game_time = DateTime.strptime("#{start_date} #{start_time}", '%m/%d/%y %l:%M %p').in_time_zone(Time.zone)
  end

end
