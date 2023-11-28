require 'rails_helper'

RSpec.describe Reservation, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe '#valid?' do
    it 'false when check_out precedes check_in' do
      # Arrange
      reservation = Reservation.new(check_in: 6.days.from_now, check_out: 4.days.from_now)
      # Act
      reservation.valid?
      # Assert
      expect(reservation.errors.full_messages).to include('Data de entrada deve ser menor que a data final')
    end
  end

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
      reservation = Reservation.new(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room, status: :canceled)
      # Act
      travel_to 0.days.from_now.change(hour: 10) do
        reservation.save!
      end
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

  describe '#active' do
    it 'false when check_in is in the future' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 3.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room)
      # Act
      result = reservation.active
      # Assert
      expect(result).to eq(false)
    end

    it 'true when check_in is today' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 0.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room)
      # Act
      result = reservation.active
      # Assert
      expect(result).to eq(true)
    end
    
    it 'saves datetime_check_in' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 0.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                        room: room)
      # Act
      reservation.active
      # Assert
      expect(reservation.additionals.datetime_check_in).to be_within(1.second).of(DateTime.now)
    end
  end

  describe '#finished' do
    context 'successfully' do
      it 'save datetime_check_out' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: innkeeper, status: :active)
        room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                            max_occupancy: 2, value: 20000, inn: inn, status: :active)
        reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                          room: room)
        travel_to 5.days.from_now do
          reservation.active
        end
        # Act
        travel_to 15.days.from_now
        reservation.finished
        # Assert
        expect(reservation.reload.additionals.datetime_check_out).to be_within(1.second).of(DateTime.now)
        travel_back
      end

      it 'update status' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: innkeeper, status: :active)
        room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                            max_occupancy: 2, value: 20000, inn: inn, status: :active)
        reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                          room: room)
        travel_to 5.days.from_now do
          reservation.active
        end
        # Act
        travel_to 15.days.from_now do
          reservation.finished
        end
        # Assert
        expect(reservation.reload.status).to eq('finished')
      end

      context 'calculate and update total_value' do
        it 'after the informed check out day' do
          # Arrange
          innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
          address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
          inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: address, user: innkeeper, status: :active)
          room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 20000, inn: inn, status: :active)
          reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                            room: room)
          travel_to 5.days.from_now do
            reservation.active
          end
          total_value_before_finishing = reservation.total_value
          # Act
          travel_to 16.days.from_now
          reservation.finished
          # Assert
          expect(reservation.reload.total_value).to eq(240000)
          expect(reservation.reload.total_value).not_to eq(total_value_before_finishing)
          travel_back
        end

        it 'before inn check out time' do
          # Arrange
          innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
          address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
          inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: address, user: innkeeper, status: :active)
          inn.inn_additional.update!(check_in: '12:00', check_out: '11:00')
          room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200_00, inn: inn, status: :active)
          PricePeriod.create!(start_date: 15.days.from_now, end_date: 20.days.from_now, value: 100_00, room: room)
          reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                            room: room)
          travel_to 5.days.from_now do
            reservation.active
          end
          # Act
          travel_to 16.days.from_now.change(hour: 10)
          reservation.finished
          # Assert
          expect(reservation.reload.total_value).to eq(2200_00)
          travel_back
        end

        it 'after inn check out time' do
          # Arrange
          innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
          address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
          inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: address, user: innkeeper, status: :active)
          inn.inn_additional.update!(check_in: '12:00', check_out: '11:00')
          room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200_00, inn: inn, status: :active)
          PricePeriod.create!(start_date: 15.days.from_now, end_date: 20.days.from_now, value: 100_00, room: room)
          reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                            room: room)
          travel_to 5.days.from_now do
            reservation.active
          end
          # Act
          travel_to 16.days.from_now.change(hour: 13)
          reservation.finished
          # Assert
          expect(reservation.reload.total_value).to eq(2300_00)
          travel_back
        end
      end
    end

    it 'reservation needs to be active' do
      # Arrange
      innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: innkeeper, status: :active)
      room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 20000, inn: inn, status: :active)
      reservation = Reservation.create!(check_in: 5.days.from_now, check_out: 15.days.from_now, guests: 2, 
                                        room: room)
      # Act
      travel_to 6.days.from_now do
        reservation.finished
      end
      # Assert
      expect(reservation.reload.status).not_to eq('finished')
    end
  end
end