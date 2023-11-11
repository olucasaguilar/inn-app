require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: '', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address, user: user)
        # Act
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end

      it 'false when social_name is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: '', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address, user: user)
        # Act
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end

      it 'false when cnpj is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '', 
                      phone: '11999999999', email: 'alemao@gmail.com', address: address, user: user)
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
      
      it 'false when email is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.create!(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                  state: 'SP', city: 'São Paulo', zip_code: '05412000')                                  
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: '', address: address, user: user)
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
      
      it 'false when address is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        inn = Inn.new(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'alemao@gmail.com', user: user)
        # Act     
        result = inn.valid?      
        # Assert
        expect(result).to eq false
      end
    end

    it 'false when user isn\'t innkeeper' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
      inn = Inn.new(user: user)
      
      # Act
      inn.valid?
      
      # Assert
      expect(inn.errors.full_messages).to include('Usuário não é um proprietário de pousada')
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
