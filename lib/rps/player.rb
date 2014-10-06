require 'digest'

class Player < ActiveRecord::Base

  validates :username, uniqueness: {case_sensitive: false}, presence: true 
  validates :email, uniqueness: true, presence: true
  
  has_many :game_players
  has_many :games, through: :game_players
  has_many :tournament_players
  has_many :tournaments, through: :tournament_players
  has_many :moves

  def self.encrypt(password)
    Digest::SHA2.hexdigest(password)
  end

  def self.decrypt(password)
    self.password_hash == Player.encrypt(password)
  end
end