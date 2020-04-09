class CreateCountryStats < ActiveRecord::Migration[5.2]
  def change
    create_table :country_stats do |t|
      t.references :country, foreign_key: true
      t.bigint :confirmed, :default => 0
      t.bigint :recovered, :default => 0
      t.bigint :deaths, :default => 0

      t.timestamps
    end
  end
end
