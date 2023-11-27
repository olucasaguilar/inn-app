class RemoveDafaultAdditionalsFromReservations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservations, :reservation_additionals_id, nil
  end
end
