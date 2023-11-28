class RemoveDefaultValuePaymentMethodFromReservationAdditionals < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservation_additionals, :payment_method_id, nil
  end
end
