class Session < ApplicationRecord
  belongs_to :game
  belongs_to :tournament

  validates :game, uniqueness: { scope: :tournament, message: 'This combination Game/Tournament already exists' }
end
