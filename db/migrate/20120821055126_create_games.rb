class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :home
      t.string :opponent
      t.datetime :kickoff

      t.timestamps
    end
  end
end
