class AddInnkeeperToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :innkeeper, :boolean, default: false
  end
end
