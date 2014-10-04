class AddStatusToGame < ActiveRecord::Migration
  def change
    # TODO
    add_column :games, :status, :string, :default => "active"
  end
end
