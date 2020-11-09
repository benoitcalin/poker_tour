class Player < ApplicationRecord
  has_many :results, dependent: :destroy
  has_many :tournament_results, dependent: :destroy

  validates :name, uniqueness: true
end
