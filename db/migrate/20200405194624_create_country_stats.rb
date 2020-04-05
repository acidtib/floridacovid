class CreateCountryStats < ActiveRecord::Migration[5.2]
  def change
    create_table :country_stats do |t|
      t.references :country, foreign_key: true
      t.bigint :confirmed
      t.bigint :recovered
      t.bigint :deaths

      t.timestamps
    end
  end
end
