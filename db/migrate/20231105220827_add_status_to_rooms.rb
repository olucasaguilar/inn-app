class AddStatusToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :status, :boolean
  end
end
