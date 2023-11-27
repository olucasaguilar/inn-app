class AddTotalValueToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :total_value, :integer
  end
end
