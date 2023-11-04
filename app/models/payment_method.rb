class PaymentMethod < ApplicationRecord
  belongs_to :additional_information
  validates :name, presence: true
end
