class CreateCountyStats < ActiveRecord::Migration[5.2]
  def change
    create_table :county_stats do |t|
      t.references :county, foreign_key: true
      t.bigint :residents, :default => 0
      t.bigint :non_residents, :default => 0
      t.bigint :deaths, :default => 0

      t.timestamps
    end
  end
end
