class AddCodeToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :code, :string
  end
end
