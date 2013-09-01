class ChangeDateFormatInGame < ActiveRecord::Migration
  def up
    change_column :games, :game_date, :datetime
    change_column :games, :game_time, :datetime
  end

  def down
    change_column :games, :game_date, :date
    change_column :games, :game_time, :time
  end
end
