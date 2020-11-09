class Result < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :game, uniqueness: { scope: :player, message: 'This combination Game/Player already exists' }
end
