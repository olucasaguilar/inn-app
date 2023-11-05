class AddAttributesToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :bathroom, :boolean
    add_column :rooms, :balcony, :boolean
    add_column :rooms, :air_conditioning, :boolean
    add_column :rooms, :tv, :boolean
    add_column :rooms, :wardrobe, :boolean
    add_column :rooms, :safe, :boolean
    add_column :rooms, :accessible, :boolean
  end
end
