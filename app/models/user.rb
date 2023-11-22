class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one :inn
  has_one :guest_user
         
  validates_presence_of :name

  after_create :create_guest_user_table_to_non_innkeepers

  private

  def create_guest_user_table_to_non_innkeepers
    GuestUser.create!(user: self) unless self.innkeeper?
  end
end
