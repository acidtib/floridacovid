class CreateCountyStats < ActiveRecord::Migration[5.2]
  def change
    create_table :county_stats do |t|
      t.references :county, foreign_key: true
      t.bigint :residents
      t.bigint :non_residents
      t.bigint :deaths

      t.timestamps
    end
  end
end
