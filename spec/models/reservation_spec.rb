require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'generate random code' do
    it 'when create reservation' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                  max_occupancy: 2, value: 20000, inn: inn, status: :active)
      user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
      user.guest_user.update!(cpf: '12345678900')
      reservation = Reservation.new(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
      # Act
      reservation.save!
      result = reservation.code
      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq(8)
    end
    
    it 'and code is unique' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                  max_occupancy: 2, value: 20000, inn: inn, status: :active)
      user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
      user.guest_user.update!(cpf: '12345678900')
      first_reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
      second_reservation = Reservation.new(check_in: 1.days.from_now, check_out: 5.days.from_now, guests: 2, room: room, user: user)
      # Act
      second_reservation.save!
      # Assert
      expect(second_reservation.code).not_to eq(first_reservation.code)
    end
    
    it 'and code does not change when update reservation' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                  max_occupancy: 2, value: 20000, inn: inn, status: :active)
      user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
      user.guest_user.update!(cpf: '12345678900')
      reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
      original_code = reservation.code
      # Act
      reservation.update!(status: :canceled)
      # Assert
      expect(reservation.code).to eq(original_code)
    end
  end

  describe 'calculate total value' do
    it 'with no custom price periods' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room, status: :canceled)
      # Act
      total_value = reservation.total_value
      # Assert
      expect(total_value).to eq(80000)
    end

    it 'with custom price periods' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      PricePeriod.create!(start_date: 2.days.from_now, end_date: 5.days.from_now, value: 30000, room: room)
      reservation = Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room, status: :canceled)
      # Act
      total_value = reservation.total_value
      # Assert
      expect(total_value).to eq(120000)
    end

    it 'with custom price periods and overlapping dates' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      PricePeriod.create!(start_date: 2.days.from_now, end_date: 5.days.from_now, value: 30000, room: room)
      reservation = Reservation.create!(check_in: 3.days.from_now, check_out: 6.days.from_now, guests: 2, 
                                        room: room, status: :canceled)
      # Act
      total_value = reservation.total_value
      # Assert
      expect(total_value).to eq(110000)
    end
  end
end
