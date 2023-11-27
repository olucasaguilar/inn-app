require 'rails_helper'

describe 'Innkeeper checks in reservation' do
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
    travel_to 6.days.from_now do
      login_as(innkeeper)
      visit root_path
      click_on 'Reservas'
      click_on reservation.code
      click_on 'Realizar CHECK-IN'
    end
    # Assert
    expect(current_path).to eq innkeeper_reservation_path(reservation)
    expect(page).to have_content 'Check-in realizado com sucesso!'
    expect(page).to have_content reservation.code
    expect(page).to have_content 'Status: Ativa'
    expect(page).not_to have_button 'Realizar CHECK-IN'
  end

  it 'unsuccessfully if check in date is in the future' do
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
    click_on 'Realizar CHECK-IN'
    # Assert
    expect(current_path).to eq innkeeper_reservation_path(reservation)
    expect(page).to have_content 'Check-in não pode ser realizado devido a data não ter chegado ainda.'
    expect(page).to have_content reservation.code
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_button 'Realizar CHECK-IN'
  end
end