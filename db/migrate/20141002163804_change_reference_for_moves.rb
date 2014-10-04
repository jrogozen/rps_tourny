class ChangeReferenceForMoves < ActiveRecord::Migration
  def change
   remove_reference :moves, :user
   add_reference :moves, :player, index: true
  end
end
