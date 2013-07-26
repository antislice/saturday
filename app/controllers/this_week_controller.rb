class ThisWeekController < ApplicationController
  def game
  
    @games = Game.all
    #saturday = DateTime.new(2012, 9, 17, 3, 0, 0)  	

    @first_game = @games.at(@games.index{|g| g.kickoff.yday >= Date.today.yday})
		
	#	@firstGame = Game.new
	#	@firstGame.home = true
	#	@firstGame.opponent = "U$C (2-0)"
	#	@firstGame.kickoff = DateTime.new(2012, 9, 15, 16, 30, 0)
    
    if @first_game.opponent == "Kal"
      @answer = "Sort of!"
    elsif @first_game.home and Date.today.day == @first_game.kickoff.day
	  @answer = "It's Saturday!"
    elsif @first_game.home
	  @answer = "Yes!"
    else
	  @answer = "No."
    end
    
    @home_or_away = @first_game.home ? "home" : "away"
  end
end
