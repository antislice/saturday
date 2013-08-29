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

      Rails.logger.debug "read in this game from json: #{game.pretty_print}"
      game.save!
    end

    Rails.logger.info "there are currently #{Game.count} games saved after importing starter data"
    update_from_ics
  end

  def self.update_from_ics
    Rails.logger.debug 'parsing calendar...'

    raw_file = File.open('yahoo-calendar.ics').read
    cal = Icalendar.parse(raw_file).first

    cal.events.each do |event|
      start_datetime = event.dtstart.in_time_zone(Time.zone)
      game = Game.find_by_game_date(start_datetime)

      next if game.nil? # make a new game obj or something... (iff it's after the last game)

      Rails.logger.debug "found this game: #{game.pretty_print}" unless game.nil?

      # todo there's probably a better way to do "update only if different"
      if game.game_time != start_datetime
        Rails.logger.debug 'the game has a new time!'
        game.game_time = game.game_date = start_datetime
        # game.network = event.something...
        game.save

        Rails.logger.debug "new game info: #{game.pretty_print}"
      end
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
