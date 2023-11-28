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
  before_validation :set_total_value, on: :create

  enum status: { pending: 0, canceled: 10, active: 20, finished: 30 }

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

  def finished
    return false unless self.active?    
    self.finished!
    set_datetime_check_out
    check_in = self.check_in
    check_out = self.additionals.datetime_check_out.to_date
    self.update!(total_value: calculate_total_value(check_in, check_out))
    true
  end

  private

  def calculate_total_value(check_in, check_out)
    total_value = 0
  
    (check_in..check_out).each do |date|
      price_period = find_price_period(date)
  
      if price_period
        total_value += calculate_price_for_date(date, check_out, price_period)
      else
        total_value += self.room.value
      end
    end
  
    total_value
  end  

  def find_price_period(date)
    self.room.price_periods.find do |price_period|
      price_period.start_date <= date && price_period.end_date >= date
    end
  end
  
  def calculate_price_for_date(date, check_out, price_period)
    if date == check_out && self.id.present? && Time.now.hour > self.room.inn.additionals.check_out.hour
      self.room.value
    else
      price_period.value
    end
  end  

  def set_total_value
    return if self.check_in.nil? || self.check_out.nil?
    self.total_value = calculate_total_value(self.check_in, self.check_out)
  end

  def create_additionals
    self.create_additionals!(datetime_check_in: DateTime.now)
  end

  def set_datetime_check_out
    self.additionals.update!(datetime_check_out: DateTime.now)
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
