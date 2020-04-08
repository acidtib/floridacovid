class CreateAgeStats < ActiveRecord::Migration[5.2]
  def change
    create_table :age_stats do |t|
      t.references :state, foreign_key: true
      t.bigint :a_0_4, :default => 0
      t.bigint :a_5_14, :default => 0
      t.bigint :a_15_24, :default => 0
      t.bigint :a_25_34, :default => 0
      t.bigint :a_35_44, :default => 0
      t.bigint :a_45_54, :default => 0
      t.bigint :a_55_64, :default => 0
      t.bigint :a_65_74, :default => 0
      t.bigint :a_75_84, :default => 0
      t.bigint :a_85plus, :default => 0

      t.timestamps
    end
  end
end
