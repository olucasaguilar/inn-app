class Inn < ApplicationRecord
  after_create :create_inn_additional

  belongs_to :address
  belongs_to :user
  has_one :inn_additional
  has_one :additionals, class_name: 'InnAdditional'
  has_many :rooms

  validates :name, :social_name, :cnpj, :phone, :email, presence: true
  validates_associated :address

  enum status: { inactive: 0, active: 1 }

  after_initialize :set_defaults

  validate :user_is_innkeeper

  def reviews
    reviews = []
    
    rooms.each do |room|
      room.reservations.each do |reservation|
        reviews << reservation.review unless reservation.review.nil?
      end
    end

    reviews
  end

  def average_rating
    average_rating = 0

    reviews.each do |review|
      average_rating += review.rating
    end

    reviews.count > 0 ? average_rating / reviews.count : nil
  end

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