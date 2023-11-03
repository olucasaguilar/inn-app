class CreateInns < ActiveRecord::Migration[7.0]
  def change
    create_table :inns do |t|
      t.string :name
      t.string :social_name
      t.string :cnpj
      t.string :phone
      t.string :email
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
