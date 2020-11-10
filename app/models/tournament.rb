class Tournament < ApplicationRecord
  belongs_to :user
  has_many :participations, dependent: :destroy

  has_many :tournament_results, dependent: :destroy
  has_many :tournament_players, through: :tournament_results, class_name: "Player", foreign_key: "player_id", source: :player

  has_many :sessions, dependent: :destroy
  has_many :games, through: :sessions
  has_many :results, through: :games
  has_many :players, through: :results

  validates :name, uniqueness: true

  def updated_player_results(player)
    {
      games: calculate_games(player),
      average_position: calculate_average_position,
      reentries: calculate_reentries,
      bets: calculate_bets,
      earnings: calculate_earnings,
      net_earnings: calculate_net_earnings,
      earnings_by_game: calculate_earnings_by_game,
      kills: calculate_kills,
      bounties: calculate_bounties
    }
  end

  private

  def calculate_games(player)
    @player_results = results.where(player: player)
    @games = @player_results.count
  end

  def calculate_average_position
    (@player_results.map(&:position).sum / @games).round(2)
  end

  def calculate_reentries
    @player_results.map(&:reentries).sum
  end

  def calculate_kills
    @player_results.map(&:kills).sum
  end

  def calculate_bounties
    @player_results.map(&:bounties).sum
  end

  def calculate_bets
    @bets = @player_results.map(&:game).map(&:price).sum
    @player_results.each do |result|
      @bets += result.reentries * result.game.price
    end
    @bets
  end

  def calculate_earnings
    @earnings = @player_results.map(&:earnings).sum
  end

  def calculate_net_earnings
    (@earnings - @bets).round(2)
  end

  def calculate_earnings_by_game
    ((@earnings - @bets) / @games).round(2)
  end
end
