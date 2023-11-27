class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_one :additionals, class_name: 'ReservationAdditional'

  validates :check_in, :check_out, :guests, presence: true
  validate :dates_must_not_be_reserved
  validate :start_date_must_be_less_than_end_date
  validate :guests_must_not_exceed_room_capacity

  before_validation :set_innkeeper_as_user, on: :create
  before_validation :generate_code, on: :create

  enum status: { pending: 0, canceled: 10, active: 20 }

  def total_value
    (self.check_in..self.check_out).map do |date|
      price_period = self.room.price_periods.find { |price_period| price_period.start_date <= date && price_period.end_date >= date }
      price_period.present? ? price_period.value : self.room.value
    end.sum
  end

  def cancel
    return false if self.check_in < 7.days.from_now
    self.canceled!
    true
  end

  def active
    return false if self.check_in > 0.days.from_now.to_date
    self.active!
    create_additionals
    true
  end

  def cancel_innkeeper
    return false if self.active?
    return false if self.check_in >= 2.days.ago
    self.canceled!
    true
  end

  private

  def create_additionals
    self.create_additionals!(datetime_check_in: DateTime.now)
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def set_innkeeper_as_user
    return if self.room.nil?
    return if self.user.present?
    
    innkeeper = self.room.inn.user
    self.user = innkeeper
  end
  
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

  def start_date_must_be_less_than_end_date
    unless self.check_in.nil? || self.check_out.nil?
      if self.check_in > self.check_out
        errors.add(:check_in, "deve ser menor que a data final")
      end
    end
  end
end
