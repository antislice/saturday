class Game < ActiveRecord::Base
  attr_accessible :home, :kickoff, :opponent, :location
end
