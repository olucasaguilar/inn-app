require 'rails_helper'

describe 'Visitor view inns' do
  include ActiveSupport::Testing::TimeHelpers
  
  it 'from the homepage' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 20000, inn: inn, status: :active)
    third_address = Address.new(street: 'Avenida das Flores, 500', neighborhood: 'Jardim Primavera',
                                state: 'RJ', city: 'Rio de Janeiro', zip_code: '22334455')
    Inn.create!(name: 'Hotel Primavera', social_name: 'Hotel Primavera LTDA',
                cnpj: '98765432109876', phone: '2122223333', email: 'hotelprimavera@example.com',
                address: third_address, user: innkeeper, status: :active)
    fourth_address = Address.new(street: 'Praça Central, 70', neighborhood: 'Centro',
                                 state: 'MG', city: 'Belo Horizonte', zip_code: '54321098')
    Inn.create!(name: 'Hotel Minas Gerais', social_name: 'Hotel Minas Gerais LTDA',
                cnpj: '56789012345670', phone: '3133334444', email: 'hotelmg@example.com',
                address: fourth_address, user: innkeeper, status: :active)
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
    visit root_path

    # Assert
    expect(page).to have_content 'Lista de Pousadas'

    within 'div#recent-inns' do
      expect(page).to have_content 'Recentes'
      expect(page).to have_link 'Hotel Minas Gerais'
      expect(page).to have_content 'Cidade: Belo Horizonte'
      expect(page).to have_content 'Nota Média: Sem avaliações'

      expect(page).to have_link 'Hotel Primavera'
      expect(page).to have_content 'Cidade: Paulo'
      expect(page).to have_content 'Nota Média: Sem avaliações'

      expect(page).to have_link 'Pousada do Russo'
      expect(page).to have_content 'Cidade: Rio de Janeiro'
      expect(page).to have_content 'Nota Média: 3'

      expect(page).not_to have_link 'Pousada do Alemão'
      expect(page).not_to have_content 'Cidade: São Paulo'
      expect(page).to have_content 'Nota Média: Sem avaliações'
    end

    within 'div#inns' do
      expect(page).to have_link 'Pousada do Alemão'
      expect(page).to have_content 'Cidade: São Paulo'
      expect(page).to have_content 'Nota Média: Sem avaliações'
    end
  end
end
