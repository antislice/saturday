class RemoveHomeFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :home
  end
end
