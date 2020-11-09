class Game < ApplicationRecord
  has_many :sessions
  has_many :results, dependent: :destroy
  has_many :players, through: :results

  validates :name, uniqueness: true

  def price
    buyin + rake
  end

  def total_players
    total_registrations - total_reentries
  end

  def prize_pool
    buyin * total_registrations
  end
end
