class DefaultStatus < ActiveRecord::Migration
  def change
    # TODO
    remove_column :game_players, :status
    add_column :game_players, :status, :string, :default => "active"
  end
end
