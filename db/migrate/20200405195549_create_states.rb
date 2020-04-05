class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.references :country, foreign_key: true
      t.string :name
      t.string :slug
      t.string :lat
      t.string :long

      t.timestamps
    end
  end
end
