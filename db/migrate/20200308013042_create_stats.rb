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
      t.integer :recovered
      t.string :last_update
      t.integer :age_0_9
      t.integer :age_10_19
      t.integer :age_20_29
      t.integer :age_30_39
      t.integer :age_40_49
      t.integer :age_50_59
      t.integer :age_60_69
      t.integer :age_70_79
      t.integer :age_80plus
      
      t.timestamps null: false
    end
  end
end
