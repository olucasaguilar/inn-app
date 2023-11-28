class ChangePaymentMethodNullToTrue < ActiveRecord::Migration[7.0]
  def change
    change_column_null :reservation_additionals, :payment_method_id, true
  end
end
