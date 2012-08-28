class ThisWeekController < ApplicationController
  def game
  
  	@games = Game.all
  	
  	firstGame = @games.at(@games.index{|g| g.home == true})

    if firstGame.home and Date.today.day == firstGame.kickoff.day
			@answer = "It's Saturday!"
    elsif firstGame.home
			@answer = "Yes!"
    else
			@answer = "No."
    end
  end
end
