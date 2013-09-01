class ThisWeekController < ApplicationController

  def game
  
    games = Game.all	

    @first_game = games.at(games.index{|g| g.game_date.yday >= Date.today.yday})
    
    if @first_game.home_or_away == 'home' and Date.today == @first_game.game_date
	    @answer = 'It\'s Saturday!'
    elsif @first_game.home_or_away == 'home'
	    @answer = 'Yes!'
    else
	    @answer = 'No.'
    end
    
  end
end
