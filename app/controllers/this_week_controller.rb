class ThisWeekController < ApplicationController

  def game

    @first_game = Game.order('id').find{|g| g.game_date.yday >= Date.today.yday}
    
    if @first_game.home_or_away == 'home' and Date.today.yday == @first_game.game_date.yday
	    @answer = 'It\'s Saturday!'
    elsif @first_game.home_or_away == 'home' and Date.today.cweek == @first_game.game_date.to_date.cweek
	    @answer = 'Yes!'
    else
	    @answer = 'No.'
    end
    
  end

  def about
  end
end
