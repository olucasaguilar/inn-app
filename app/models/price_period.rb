class PricePeriod < ApplicationRecord
  belongs_to :room
  validate :dates_must_not_be_within_a_period
  validate :start_date_must_be_less_than_end_date

  private

  def dates_must_not_be_within_a_period
    periods = PricePeriod.where(room_id: self.room_id)
    periods.each do |period|
      unless self.id == period.id
        if self.start_date >= period.start_date && self.start_date <= period.end_date
          errors.add(:start_date, "já está dentro de um período cadastrado")
        end
        if self.end_date >= period.start_date && self.end_date <= period.end_date
          errors.add(:end_date, "já está dentro de um período cadastrado")
        end
      end
    end
  end

  def start_date_must_be_less_than_end_date
    if self.start_date > self.end_date
      errors.add(:start_date, "deve ser menor que a data final")
    end
  end
end
