class Room < ApplicationRecord
  belongs_to :inn
  has_many :price_periods
  validates :name, :description, :dimension, :max_occupancy, :value, presence: true

  enum status: { inactive: 0, active: 1 }
end
