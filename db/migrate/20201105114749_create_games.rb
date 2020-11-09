class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :winamax_id
      t.datetime :start_time
      t.datetime :end_time
      t.float :total_registrations
      t.float :total_reentries
      t.float :buyin
      t.float :rake

      t.timestamps
    end
  end
end
