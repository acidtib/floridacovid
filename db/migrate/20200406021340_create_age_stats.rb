class CreateAgeStats < ActiveRecord::Migration[5.2]
  def change
    create_table :age_stats do |t|
      t.references :state_stat, foreign_key: true
      t.bigint :a_0_4
      t.bigint :a_5_14
      t.bigint :a_15_24
      t.bigint :a_25_34
      t.bigint :a_35_44
      t.bigint :a_45_54
      t.bigint :a_55_64
      t.bigint :a_65_74
      t.bigint :a_75_84
      t.bigint :a_85plus

      t.timestamps
    end
  end
end
