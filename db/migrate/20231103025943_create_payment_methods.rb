class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.references :additional_information, null: false, foreign_key: true

      t.timestamps
    end
  end
end
