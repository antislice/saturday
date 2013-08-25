class SplitKickoffTimeIntoTwoFields < ActiveRecord::Migration
  def up
    add_column :games, :game_date, :date
    add_column :games, :game_time, :time
    remove_column :games, :kickoff
  end

  def down
    remove_columns :games, :game_date, :game_time
    add_column :games, :kickoff, :datetime
  end
end
