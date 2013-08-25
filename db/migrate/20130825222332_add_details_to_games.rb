class AddDetailsToGames < ActiveRecord::Migration
  def change
    add_column :games, :note, :string
    add_column :games, :network, :string
  end
end
