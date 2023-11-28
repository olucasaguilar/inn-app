class ReservationAdditional < ApplicationRecord
  belongs_to :reservation
  belongs_to :payment_method, optional: true
end
