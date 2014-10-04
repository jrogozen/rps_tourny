class AddPlayerToMove < ActiveRecord::Migration
  def change
    # TODO
    add_reference :moves, :user, index: true
  end
end
