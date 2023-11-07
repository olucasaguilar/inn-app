require 'rails_helper'

RSpec.describe PricePeriod, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when value is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        pp = PricePeriod.new(start_date: "2015-01-01", end_date: "2015-01-10", value: nil, room: room)
        # Act
        result = pp.valid?
        # Assert
        expect(result).to eq false
      end
      
      it 'false when start_date is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        pp = PricePeriod.new(start_date: nil, end_date: "2015-01-10", value: 200, room: room)
        # Act
        result = pp.valid?
        # Assert
        expect(result).to eq false
      end
      
      it 'false when end_date is empty' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        pp = PricePeriod.new(start_date: "2015-01-10", end_date: nil, value: 200, room: room)
        # Act
        result = pp.valid?
        # Assert
        expect(result).to eq false
      end
      
      it 'false when start_date is after end_date' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        pp = PricePeriod.new(start_date: "2015-01-15", end_date: "2015-01-10", value: 200, room: room)
        # Act
        result = pp.valid?
        # Assert
        expect(result).to eq false
      end
      
      it 'false when value is not positive' do
        # Arrange
        user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: user)
        room = Room.new(name: '', description: 'Quarto com vista para o mar', dimension: 20,
                    max_occupancy: 2, value: 200, inn: inn)
        pp = PricePeriod.new(start_date: "2015-01-01", end_date: "2015-01-10", value: -5, room: room)
        # Act
        result = pp.valid?
        # Assert
        expect(result).to eq false
      end
    end

    it 'false when start_date is within a period' do
      # Arrange
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      room = Room.create!(name: 'Pousada Alegria', description: 'Quarto com vista para o mar', dimension: 20,
                      max_occupancy: 2, value: 200, inn: inn)
      PricePeriod.create!(start_date: "2015-01-01", end_date: "2015-01-10", value: 125, room: room)
      pp = PricePeriod.new(start_date: "2015-01-01", end_date: "2015-01-15", value: 150, room: room)
      # Act
      result = pp.valid?
      # Assert
      expect(result).to eq false
    end
  end
end
