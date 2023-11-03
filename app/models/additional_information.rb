class AdditionalInformation < ApplicationRecord
  belongs_to :inn
  has_many :payment_methods
end