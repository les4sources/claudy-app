class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.references :team, null: false, foreign_key: true
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :email
      t.text :notes

      t.timestamps
    end
  end
end
