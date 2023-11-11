class SetDefaultValuesInRooms < ActiveRecord::Migration[7.0]
  def change
    change_column_default :rooms, :bathroom, false
    change_column_default :rooms, :balcony, false
    change_column_default :rooms, :air_conditioning, false
    change_column_default :rooms, :tv, false
    change_column_default :rooms, :wardrobe, false
    change_column_default :rooms, :safe, false
    change_column_default :rooms, :accessible, false
    change_column_default :rooms, :status, false
  end
end
