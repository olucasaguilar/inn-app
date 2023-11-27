require 'rails_helper'

describe 'Innkeeper edit reservation status' do
  it 'and isn\'t the owner' do
    # Arrange
    first_innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: first_innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 20000, inn: inn, status: :active)
    guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    guest.guest_user.update!(cpf: '12345678900')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    other_innkeeper = User.create!(name: 'Marcia', email: 'marcia@gmail.com', password: '123456', innkeeper: true)
    other_address = Address.new(street: 'Rua Segunda, 654', neighborhood: 'Bairro Segundo', 
                                state: 'SP', city: 'São Paulo', zip_code: '65498744')
    Inn.create!(name: 'Pousada Segunda', social_name: 'Pousada Segunda LTDA', 
                cnpj: '12345555551234', phone: '11999333999', email: 'psegunda@gmail.com', 
                address: other_address, user: other_innkeeper, status: :active)
    # Act
    login_as(other_innkeeper)
    post(active_innkeeper_reservation_path(reservation))
    # Assert
    expect(response).to redirect_to(root_path)
  end
end