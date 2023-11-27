require 'rails_helper'

describe 'Innkeeper cancels reservation' do
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
    guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    guest.guest_user.update!(cpf: '12345678900')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    # Act
    travel_to 8.days.from_now do
      login_as(innkeeper)
      visit root_path
      click_on 'Reservas'
      click_on reservation.code
      click_on 'Cancelar reserva'
    end
    # Assert
    expect(page).to have_content 'Reserva cancelada com sucesso!'
    expect(page).not_to have_content reservation.code
    expect(page).not_to have_content 'Status: Ativa'
    expect(current_path).to eq innkeeper_reservations_path
  end

  it 'unsucessfully if check in was made' do
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
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    travel_to 6.days.from_now do
      reservation.active
    end
    # Act
    login_as(innkeeper)
    visit root_path
    click_on 'Reservas'
    click_on 'Estadias Ativas'
    click_on reservation.code
    # Assert
    expect(page).not_to have_content 'Cancelar reserva'
  end
  
  it 'unsucessfully if check in isn\'t 2 days late' do
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
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    # Act
    login_as(innkeeper)
    visit root_path
    click_on 'Reservas'
    click_on reservation.code
    click_on 'Cancelar reserva'
    # Assert
    expect(page).to have_content 'Reserva só pode ser cancelada após 2 dias do check-in'
    expect(page).to have_content reservation.code
    expect(page).to have_content 'Status: Pendente'
  end
end
