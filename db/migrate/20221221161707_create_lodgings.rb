class CreateLodgings < ActiveRecord::Migration[7.0]
  def change
    create_table :lodgings do |t|
      t.references :location, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :summary
      t.integer :price_night_cents
      t.integer :price_weekend_cents
      t.boolean :party_hall_availability, default: false

      t.timestamps
    end
  end
end
