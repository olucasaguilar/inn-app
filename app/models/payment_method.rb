class PaymentMethod < ApplicationRecord
  belongs_to :inn_additional
  validates :name, presence: true
  has_many :reservation_additionals
end
