class CreateStats < ActiveRecord::Migration[6.0]
  def change
    create_table :stats do |t|
      t.bigint :state_id
      t.integer :positive_residents
      t.integer :cases_repatriated
      t.integer :non_residents
      t.integer :deaths
      t.integer :results_negative
      t.integer :results_pending
      t.integer :being_monitored
      t.integer :total_monitored
      t.string :last_update
      
      t.timestamps null: false
    end
  end
end
