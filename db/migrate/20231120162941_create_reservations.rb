class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.date :check_in
      t.date :check_out
      t.integer :guests
      t.references :room, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
