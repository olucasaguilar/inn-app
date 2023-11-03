class CreateInnAdditionalInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :inn_additional_informations do |t|
      t.text :description
      t.text :policies
      t.time :check_in
      t.time :check_out
      t.boolean :pets
      t.references :inn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
