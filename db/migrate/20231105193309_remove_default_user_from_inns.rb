class RemoveDefaultUserFromInns < ActiveRecord::Migration[7.0]
  def change
    change_column_default :inns, :user_id, nil
  end
end
