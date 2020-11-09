class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  validates :user, uniqueness: { scope: :tournament, message: 'This combination User/Tournament already exists' }
end
