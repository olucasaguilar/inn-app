class Inn < ApplicationRecord
  after_create :create_inn_additional

  belongs_to :address
  belongs_to :user
  has_one :inn_additional
  has_many :rooms

  validates :name, :social_name, :cnpj, :phone, :email, presence: true
  validates_associated :address

  enum status: { inactive: 0, active: 1 }

  after_initialize :set_defaults

  validate :user_is_innkeeper

  private

  def create_inn_additional
    InnAdditional.create!(inn: self, check_in: '12:00', 
                          check_out: '12:00') if self.inn_additional.nil?
  end

  def set_defaults
    self.status ||= :inactive
  end
  
  def user_is_innkeeper
    if self.user.innkeeper == false
      errors.add(:user, "não é um proprietário de pousada")
    end
  end
end