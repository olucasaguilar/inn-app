class AddReservationToReservationAdditional < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservation_additionals, :reservation, null: false, foreign_key: true
  end
end
