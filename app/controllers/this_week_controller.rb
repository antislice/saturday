class ThisWeekController < ApplicationController
  def game
  
    @games = Game.all
    #saturday = DateTime.new(2012, 9, 17, 3, 0, 0)  	

    @firstGame = @games.at(@games.index{|g| g.kickoff.yday >= Date.today.yday})
		
	#	@firstGame = Game.new
	#	@firstGame.home = true
	#	@firstGame.opponent = "U$C (2-0)"
	#	@firstGame.kickoff = DateTime.new(2012, 9, 15, 16, 30, 0)
    
    if @firstGame.opponent == "Kal"
      @answer = "Sort of!"
    elsif @firstGame.home and Date.today.day == @firstGame.kickoff.day
	  @answer = "It's Saturday!"
    elsif @firstGame.home
	  @answer = "Yes!"
    else
	  @answer = "No."
    end
    
  end
end
