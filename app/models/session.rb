class Session < ApplicationRecord
  belongs_to :game
  belongs_to :tournament
end
