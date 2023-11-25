class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :check_in, :check_out, :guests, presence: true
  validate :dates_must_not_be_reserved
  validate :guests_must_not_exceed_room_capacity

  enum status: { pending: 0, canceled: 10, confirmed: 20 }

  private
  
  def dates_must_not_be_reserved
    reservations = Reservation.where(room_id: self.room_id).where.not(status: :canceled)
  
    reservations.each do |reservation|
      next if self == reservation || self.check_in.nil? || self.check_out.nil?
  
      if period_overlaps?(self.check_in, self.check_out, reservation.check_in, reservation.check_out)
        errors.add(:base, 'O periodo informado está indisponível')
      end
    end
  end
  
  def period_overlaps?(date_begin_1, date_end_1, date_begin_2, date_end_2)
    date_begin_1 <= date_end_2 && date_end_1 >= date_begin_2
  end

  def guests_must_not_exceed_room_capacity
    return if self.guests.nil? || self.room.nil?
    errors.add(:base, 'O quarto não comporta a quantidade de hóspedes informada') if self.guests > self.room.max_occupancy
  end
end
