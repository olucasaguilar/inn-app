class PaymentMethod < ApplicationRecord
  belongs_to :additional_information
  validates :name, presence: true
  before_validation :set_additional_information

  private

  def set_additional_information
    self.additional_information = Inn.last.additional_information
  end
end
