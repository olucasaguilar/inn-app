class PaymentMethod < ApplicationRecord
  belongs_to :inn_additional
  validates :name, presence: true
end
