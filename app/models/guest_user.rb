class GuestUser < ApplicationRecord
  belongs_to :user

  validates :cpf, presence: true, if: :cpf_changed?
end
