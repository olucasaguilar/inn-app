class InnAdditional < ApplicationRecord
  belongs_to :inn
  has_many :payment_methods
  validates :check_in, :check_out, presence: true
end