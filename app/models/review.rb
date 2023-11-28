class Review < ApplicationRecord
  belongs_to :reservation
  
  validates :rating, presence: true
  validates :rating, numericality: { less_than_or_equal_to: 5 }
  validates :rating, numericality: { greater_than_or_equal_to: 0 }

  validate :reservation_is_finished

  private

  def reservation_is_finished
    return if self.reservation.nil?
    if self.reservation.status != 'finished'
      errors.add(:reservation, "não está finalizada")
    end
  end
end

