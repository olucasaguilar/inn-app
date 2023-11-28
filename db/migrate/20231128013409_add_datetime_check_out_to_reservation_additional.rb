class AddDatetimeCheckOutToReservationAdditional < ActiveRecord::Migration[7.0]
  def change
    add_column :reservation_additionals, :datetime_check_out, :datetime
  end
end
