class ThisWeekController < ApplicationController
  def game
    home = false
    saturday = false

    if home == true and saturday == true
	@answer = "It's Saturday!"
    elsif home == true
	@answer = "Yes!"
    else
	@answer = "No."
    end
  end
end
