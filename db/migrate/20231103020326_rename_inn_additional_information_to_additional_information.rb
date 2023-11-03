class RenameInnAdditionalInformationToAdditionalInformation < ActiveRecord::Migration[7.0]
  def change
    rename_table :inn_additional_informations, :additional_informations
  end
end
