class ThisWeekController < ApplicationController
  def game
  
#  	@games = Game.all
  	
#  	firstGame = @games.at(@games.index{|g| g.home == true})
		
		@firstGame = Game.new
		@firstGame.home = true
		@firstGame.opponent = "San Jose State University"
		@firstGame.kickoff = DateTime.new(2012, 8, 31, 19, 0, 0)

    if @firstGame.home and Date.today.day == @firstGame.kickoff.day
			@answer = "It's Saturday!"
    elsif @firstGame.home
			@answer = "Yes!"
    else
			@answer = "No."
    end
    
  end
end
