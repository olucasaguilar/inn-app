class Room < ApplicationRecord
  belongs_to :inn
  validates :name, :description, :dimension, :max_occupancy, :value, presence: true
end
