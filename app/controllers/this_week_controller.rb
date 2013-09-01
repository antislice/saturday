class ThisWeekController < ApplicationController
  def game
  
    games = Game.all
    #saturday = DateTime.new(2012, 9, 17, 3, 0, 0)  	

    @first_game = games.at(games.index{|g| g.game_date.yday >= Date.today.yday})
		
	#	@firstGame = Game.new
	#	@firstGame.home = true
	#	@firstGame.opponent = "U$C (2-0)"
	#	@firstGame.kickoff = DateTime.new(2012, 9, 15, 16, 30, 0)
    
    if @first_game.home_or_away == 'home' and Date.today == @first_game.game_date
	    @answer = 'It\'s Saturday!'
    elsif @first_game.home_or_away == 'home'
	    @answer = 'Yes!'
    else
	    @answer = 'No.'
    end
    
  end
end
