class AddManytoManyPlayersTournaments < ActiveRecord::Migration
  def change
    create_table :tournament_players do |t|
      t.belongs_to :tournament
      t.belongs_to :player
    end
  end
end
