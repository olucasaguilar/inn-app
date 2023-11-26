class RemoveDefaultUserIdFromReservations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservations, :user_id, nil
  end
end
