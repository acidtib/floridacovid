class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :slug
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
