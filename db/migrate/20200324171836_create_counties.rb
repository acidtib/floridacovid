class CreateCounties < ActiveRecord::Migration[6.0]
  def change
    create_table :counties do |t|
      t.bigint :state_id
      t.string :name
      t.string :slug
      t.integer :residents
      t.integer :non_residents
      t.integer :deaths
      t.timestamp :last_update
      
      t.timestamps null: false
    end
  end
end
