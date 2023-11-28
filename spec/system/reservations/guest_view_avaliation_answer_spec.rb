require 'rails_helper'

describe 'Guest view avaliation answer' do
  include ActiveSupport::Testing::TimeHelpers

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
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, 
                                      room: room, user: user)
    travel_to 6.days.from_now do
      reservation.active
    end
    travel_to 10.days.from_now do
      reservation.finished
    end
    review = Review.create!(rating: 5, comment: 'Ótima pousada', reservation: reservation, answer: 'Obrigado por nos avaliar!')
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Blue Room'
    # Assert
    expect(page).to have_content 'Resposta: Obrigado por nos avaliar!'
  end
end