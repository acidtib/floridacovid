class CreateCases < ActiveRecord::Migration[5.2]
  def change
    create_table :cases do |t|
      t.integer :object_id
      t.references :county, foreign_key: true
      t.references :state, foreign_key: true
      t.string :age
      t.string :age_group
      t.string :gender
      t.string :jurisdiction
      t.string :travel_related
      t.string :origin
      t.string :ed_visit
      t.string :hospitalized
      t.string :died
      t.string :case_
      t.string :contact
      t.datetime :case_date
      t.datetime :event_date
      t.datetime :chart_date

      t.timestamps
    end
  end
end
