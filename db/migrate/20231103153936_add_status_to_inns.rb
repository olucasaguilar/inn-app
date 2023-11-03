class AddStatusToInns < ActiveRecord::Migration[7.0]
  def change
    add_column :inns, :status, :integer
  end
end
