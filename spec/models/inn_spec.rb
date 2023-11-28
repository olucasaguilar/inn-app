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

  describe '#average_rating' do
    include ActiveSupport::Testing::TimeHelpers

    context 'calculate average rating' do
      it 'successfully' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: innkeeper, status: :active)
        room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                            max_occupancy: 2, value: 20000, inn: inn, status: :active)
        guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
        guest.guest_user.update!(cpf: '12345678900')
        reservation_001 = Reservation.create!(check_in: 2.days.from_now, check_out: 3.days.from_now, guests: 2, 
                                              room: room, user: guest)
        reservation_002 = Reservation.create!(check_in: 4.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                              room: room, user: guest)
        reservation_003 = Reservation.create!(check_in: 6.days.from_now, check_out: 7.days.from_now, guests: 2, 
                                              room: room, user: guest)
        travel_to 2.days.from_now do
          reservation_001.active
        end
        travel_to 3.days.from_now do
          reservation_001.finished
        end
        travel_to 4.days.from_now do
          reservation_002.active
        end
        travel_to 5.days.from_now do
          reservation_002.finished
        end
        travel_to 6.days.from_now do
          reservation_003.active
        end
        travel_to 7.days.from_now do
          reservation_003.finished
        end      
        review_001 = Review.create!(rating: 5, comment: 'Ótima pousada', reservation: reservation_001)
        review_002 = Review.create!(rating: 2, comment: 'Ótima pousada', reservation: reservation_002)
        review_003 = Review.create!(rating: 3, comment: 'Ótima pousada', reservation: reservation_003)
        # Act
        average_rating = inn.average_rating
        # Assert
        expect(average_rating).to eq(3)
      end

      it 'and there is no reviews' do
        # Arrange
        innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
        address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                              state: 'SP', city: 'São Paulo', zip_code: '05412000')
        inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                          cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                          address: address, user: innkeeper, status: :active)
        # Act
        average_rating = inn.average_rating
        # Assert
        expect(average_rating).to eq(nil)
      end
    end
  end
end
