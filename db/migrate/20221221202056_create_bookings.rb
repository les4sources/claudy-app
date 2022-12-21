class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :team, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.references :lodging, null: true, foreign_key: true
      t.date :from_date
      t.date :to_date
      t.string :status
      t.integer :adults
      t.integer :children
      t.string :payment_status
      t.string :payment_method
      t.boolean :bedsheets
      t.boolean :towels
      t.text :notes
      t.integer :shown_price_cents
      t.integer :price_cents
      t.string :invoice_status
      t.string :contract_status
      t.string :checkin_time
      t.string :options
      t.text :comments
      t.string :selected_tier
      t.string :token

      t.timestamps
    end
  end
end
