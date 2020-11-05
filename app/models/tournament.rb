class Tournament < ApplicationRecord
  has_many :participations
  has_many :sessions
  has_many :games, through: :sessions
end
