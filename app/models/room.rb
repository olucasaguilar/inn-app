class Room < ApplicationRecord
  belongs_to :inn
  
  enum status: { inactive: 0, active: 1 }

  has_many :price_periods
  has_many :reservations

  validates :name, :description, :dimension, :max_occupancy, :value, presence: true
end
