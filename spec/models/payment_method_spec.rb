require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe '#eq' do
    it 'when creating a payment method' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                        phone: '11999999999', email: 'teste@gmail.com', address: address, user: user)
      payment_method = PaymentMethod.create!(name: 'Cartão de crédito', additional_information: inn.additional_information)
      # Assert
      expect(payment_method.additional_information).to eq inn.additional_information
    end
  end
end