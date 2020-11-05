class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.references :game, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
  end
end
