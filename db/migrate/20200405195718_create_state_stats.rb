class CreateStateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :state_stats do |t|
      t.references :state, foreign_key: true
      t.bigint :positive_residents
      t.bigint :positive_non_residents
      t.bigint :deaths
      t.bigint :results_total
      t.bigint :results_negative
      t.bigint :recovered
      t.bigint :being_monitored

      t.timestamps
    end
  end
end
