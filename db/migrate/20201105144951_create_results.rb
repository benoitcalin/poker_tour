class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.float :position
      t.float :reentries, null: false, default: 0.00
      t.float :earnings
      t.float :bounties, null: false, default: 0.00
      t.float :kills, null: false, default: 0.00
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
