class CreateTournamentResults < ActiveRecord::Migration[6.0]
  def change
    create_table :tournament_results do |t|
      t.float :games
      t.float :average_position
      t.float :reentries
      t.float :bets
      t.float :kills
      t.float :bounties
      t.float :earnings
      t.float :net_earnings
      t.float :earnings_by_game
      t.references :player, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
    end
  end
end
