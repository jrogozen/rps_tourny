class AddStatstoPlayer < ActiveRecord::Migration
  def change
    # TODO
    add_column :players, :wins, :string
    add_column :players, :losses, :string
  end
end
