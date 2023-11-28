require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#valid?' do
    it 'false when rating is more than 5' do
      # Arrange
      review = Review.new(rating: 6)
      # Act
      review.valid? 
      # Assert
      expect(review.errors.full_messages).to include('Nota deve ser menor ou igual a 5')
    end

    it 'false when rating is less than 0' do
      # Arrange
      review = Review.new(rating: -1)
      # Act
      review.valid? 
      # Assert
      expect(review.errors.full_messages).to include('Nota deve ser maior ou igual a 0')
    end

    it 'false when reservations ins not finished' do
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
      reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, 
                                        room: room, user: guest)
      review = Review.new(rating: 5, comment: 'Ótima pousada', reservation: reservation)
      review.valid?
      # Assert
      expect(review.errors.full_messages).to include('Reserva não está finalizada')
    end
  end
end
