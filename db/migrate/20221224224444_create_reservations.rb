class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :location, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
