class Game < ActiveRecord::Base
  has_many :moves
  has_many :game_players
  has_many :players, through: :game_players
  belongs_to :tournament

  def fight(player1, player2)
    # do the fighting
    RockPapeScis.fight(player1, player2)
  end

end