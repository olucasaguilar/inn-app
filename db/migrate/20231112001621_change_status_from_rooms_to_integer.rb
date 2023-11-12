class ChangeStatusFromRoomsToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :rooms, :status, :integer
  end
end
