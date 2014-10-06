class Addhashpassword < ActiveRecord::Migration
  def change
    # TODO
    add_column :players, :hashed_password, :text
  end
end
