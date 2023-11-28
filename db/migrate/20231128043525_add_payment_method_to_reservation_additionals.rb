class AddPaymentMethodToReservationAdditionals < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservation_additionals, :payment_method, null: false, foreign_key: true, default: 1
  end
end