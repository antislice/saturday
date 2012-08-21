class Game < ActiveRecord::Base
  attr_accessible :home, :kickoff, :opponent
end
