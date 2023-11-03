class Inn < ApplicationRecord
  after_create :create_additional_information

  belongs_to :address
  has_one :additional_information

  validates :name, :social_name, :cnpj, :phone, :email, presence: true
  validates_associated :address

  private

  def create_additional_information
    AdditionalInformation.create!(inn: self)
  end
end
