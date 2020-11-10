class User < ApplicationRecord
  has_many :tournaments
  has_many :participations
  has_many :tournaments_participations, through: :participations, class_name: "Tournament", foreign_key: "tournament_id", source: :tournament

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


end
