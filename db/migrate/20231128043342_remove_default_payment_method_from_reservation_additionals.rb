class RemoveDefaultPaymentMethodFromReservationAdditionals < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservation_additionals, :payment_method_id, :integer
  end
end
