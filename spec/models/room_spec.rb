require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
      
      it 'false when description is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: 'Quarto 1', description: '', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
      
      it 'false when dimension is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: nil,
                    max_occupancy: 2, value: 200, inn: inn)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
      
      it 'false when max_occupancy is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 12,
                    max_occupancy: 2, value: nil, inn: inn)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
      
      it 'false when value is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 12,
                    max_occupancy: 2, value: nil, inn: inn)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
      
      it 'false when inn is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 12,
                    max_occupancy: 2, value: 200, inn: nil)
        # Act
        result = room.valid? 
        # Assert
        expect(result).to eq false
      end
    end
  end
end
