require 'rails_helper'

describe 'Guest edit reservation status' do
  it 'and isn\'t the owner' do
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
    other_user = User.create!(name: 'Oliveira', email: 'oliveira@gmail.com', password: '123456', innkeeper: false)
    other_user.guest_user.update!(cpf: '98765432100')
    # Act
    login_as(other_user)
    post(canceled_inn_room_reservation_path(inn, room, reservation))
    # Assert
    expect(response).to redirect_to(root_path)
  end
end