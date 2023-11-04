require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: '', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address)
        # Act
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end

      it 'false when social_name is empty' do
        # Arrange
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: '', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address)
        # Act
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end

      it 'false when cnpj is empty' do
        # Arrange
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address)
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
      
      it 'false when email is empty' do
        # Arrange
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: '', address: address)
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
      
      it 'false when address is empty' do
        # Arrange                             
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com')
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
    end
    
    it 'false when status is empty' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address, user: user)
      # Act     
      result = inn.status 
      # Assert
      expect(result).not_to eq nil
    end
  end
end
