class CreateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :states do |t|
      t.string :name
      t.string :slug
      t.string :latitude
      t.string :longitude
      
      t.timestamps null: false
    end
  end
end