class CreateGuestUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :guest_users do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cpf

      t.timestamps
    end
  end
end
