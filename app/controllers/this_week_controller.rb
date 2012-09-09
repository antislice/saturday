class ThisWeekController < ApplicationController
  def game
  
#  	@games = Game.all
  	
#  	firstGame = @games.at(@games.index{|g| g.home == true})
		
		@firstGame = Game.new
		@firstGame.home = true
		@firstGame.opponent = "Duke (1-0)"
		@firstGame.kickoff = DateTime.new(2012, 9, 8, 19, 30, 0)

    if @firstGame.home and Date.today.day == @firstGame.kickoff.day
			@answer = "It's Saturday!"
    elsif @firstGame.home
			@answer = "Yes!"
    else
			@answer = "No."
    end
    
  end
end
