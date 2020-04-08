class CreateStateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :state_stats do |t|
      t.references :state, foreign_key: true
      t.bigint :positive_residents, :default => 0
      t.bigint :positive_non_residents, :default => 0
      t.bigint :deaths, :default => 0
      t.bigint :results_total, :default => 0
      t.bigint :results_negative, :default => 0
      t.bigint :recovered, :default => 0
      t.bigint :being_monitored, :default => 0

      t.timestamps
    end
  end
end
