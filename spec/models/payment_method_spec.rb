require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe '#eq' do
    it 'when creating a payment method' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                        phone: '11999999999', email: 'teste@gmail.com', address: address, user: user)
      payment_method = PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: inn.inn_additional)
      # Assert
      expect(payment_method.inn_additional).to eq inn.inn_additional
    end
  end
end