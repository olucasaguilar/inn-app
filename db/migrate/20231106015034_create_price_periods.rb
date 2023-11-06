class CreatePricePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :price_periods do |t|
      t.integer :value
      t.date :start_date
      t.date :end_date
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
