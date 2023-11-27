class CreateReservationAdditionals < ActiveRecord::Migration[7.0]
  def change
    create_table :reservation_additionals do |t|
      t.references :reservation, null: false, foreign_key: true
      t.datetime :datetime_check_in

      t.timestamps
    end
  end
end
