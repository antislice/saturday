class ThisWeekController < ApplicationController
  def game
  
#  	@games = Game.all
  	
#  	firstGame = @games.at(@games.index{|g| g.home == true})
		
		@firstGame = Game.new
		@firstGame.home = false
		@firstGame.location = "Seattle, WA"
		@firstGame.opponent = "Washington (2-1)"
		@firstGame.kickoff = DateTime.new(2012, 9, 28, 2, 0, 0, '+8')
		# lawl, so I have to put this in as the UTC time + the offset?
		#dumb

    if @firstGame.home and Date.today.day == @firstGame.kickoff.day
			@answer = "It's Saturday!"
    elsif @firstGame.home
			@answer = "Yes!"
    else
			@answer = "No."
    end
    
  end
end
