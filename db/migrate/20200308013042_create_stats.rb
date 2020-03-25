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
      t.integer :age_0_4
      t.integer :age_5_14
      t.integer :age_15_24
      t.integer :age_25_34
      t.integer :age_35_44
      t.integer :age_45_54
      t.integer :age_55_64
      t.integer :age_65_74
      t.integer :age_75_84
      t.integer :age_85plus
      
      t.timestamps null: false
    end
  end
end
