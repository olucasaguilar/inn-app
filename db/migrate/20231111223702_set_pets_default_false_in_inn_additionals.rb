class SetPetsDefaultFalseInInnAdditionals < ActiveRecord::Migration[7.0]
  def change
    change_column_default :inn_additionals, :pets, false
  end
end
