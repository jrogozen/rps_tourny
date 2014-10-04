class AddStatusToTournamentPlayers < ActiveRecord::Migration
  def change
    add_column :tournament_players, :status, :string, :default => "active"
  end
end
