class AddSatustoGamePlayers < ActiveRecord::Migration
  def change
    # TODO
    add_column :game_players, :status, :string
  end
end
