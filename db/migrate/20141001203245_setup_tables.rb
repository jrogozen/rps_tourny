class SetupTables < ActiveRecord::Migration
  def change
    # TODO
    create_table :players do |t|
      t.string :username
      t.string :email
    end

    create_table :games do |t|
      t.string :winner
      t.string :loser
      t.belongs_to :tournament
    end

    create_table :moves do |t|
      t.string :move
      t.belongs_to :game
    end

    create_table :tournaments do |t|
      t.string :name
      t.string :winner
    end

    create_table :game_players do |t|
      t.belongs_to :game
      t.belongs_to :player
    end
  end
end
