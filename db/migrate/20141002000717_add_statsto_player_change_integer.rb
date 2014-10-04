class AddStatstoPlayerChangeInteger < ActiveRecord::Migration
  def change
    # TODO
    remove_column :players, :wins
    remove_column :players, :losses
    add_column :players, :wins, :integer, :default => 0
    add_column :players, :losses, :integer, :default => 0
  end
end
