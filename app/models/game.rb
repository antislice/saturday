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

      logger.debug "read in this game from json: #{game.pretty_print}"
      game.save!
    end

    logger.info "there are currently #{Game.count} games saved after importing starter data"
    update_from_ics
  end

  def self.update_from_ics
    logger.info 'getting calendar...'

    ics_from_http = Curl.get('http://sports.yahoo.com/ncaaf/teams/sss/ical.ics')
    cal = Icalendar.parse(ics_from_http.body_str).first

    logger.info 'parsing calendar...'

    cal.events.each do |event|
      start_datetime = event.dtstart.in_time_zone(Time.zone)

      game = Game.find do |g| g.game_date.yday == start_datetime.yday  end

      next if game.nil? # make a new game obj or something... (iff it's after the last game)

      logger.debug "found this game: #{game.pretty_print}" unless game.nil?

      # todo there's probably a better way to do "update only if different"
      if game.game_time != start_datetime
        logger.debug 'the game has a new time!'
        game.game_time = game.game_date = start_datetime
        # game.network = event.something...
        game.save

        logger.debug "new game info: #{game.pretty_print}"
      end
    end
    logger.info 'finished!'
  end

  def home_or_away
    location.downcase.include?('stanford') ? 'home' : 'away'
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
