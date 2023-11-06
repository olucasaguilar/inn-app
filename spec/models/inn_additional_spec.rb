require 'rails_helper'

RSpec.describe InnAdditional, type: :model do
  describe '#nil?' do
    it 'false when additional_information is nil' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
      inn = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                    phone: '11999999999', email: 'alemao@gmail.com', address: address, user: user)
      result = inn.inn_additional
      # Assert
      expect(result).not_to eq nil
      expect(result).to be_a InnAdditional
    end
  end
end