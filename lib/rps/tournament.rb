class Tournament < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  has_many :games
  has_many :tournament_players
  has_many :players, through: :tournament_players
end