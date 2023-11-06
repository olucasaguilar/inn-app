class RenameAdditionalInformationsTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :additional_informations, :inn_additionals
    rename_column :payment_methods, :additional_information_id, :inn_additional_id
  end
end