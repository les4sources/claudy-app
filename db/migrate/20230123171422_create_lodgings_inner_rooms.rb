class CreateLodgingsInnerRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :lodgings_inner_rooms do |t|
      t.references :lodging, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
