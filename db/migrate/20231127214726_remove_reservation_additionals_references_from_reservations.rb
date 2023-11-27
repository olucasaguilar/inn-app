class RemoveReservationAdditionalsReferencesFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reservations, :reservation_additionals, null: false, foreign_key: true
  end
end
