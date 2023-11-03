class Address < ApplicationRecord
  has_one :inn

  validates :street, :neighborhood, :state, :city, :zip_code, presence: true
end
