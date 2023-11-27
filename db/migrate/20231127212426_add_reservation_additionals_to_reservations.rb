class AddReservationAdditionalsToReservations < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservations, :reservation_additionals, null: false, foreign_key: true, default: 1
  end
end
