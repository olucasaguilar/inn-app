require 'rails_helper'

describe 'Innkeeper view reservations' do
  it 'from home page' do
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
    # Act
    login_as(innkeeper)
    visit root_path
    click_on 'Reservas'
    # Assert
    expect(page).to have_content 'Reservas'
    expect(page).to have_content 'Código da reserva: ' + reservation.code
    expect(page).to have_content 'Quarto: Blue Room'
    expect(page).to have_content 'Data de entrada: ' + I18n.l(reservation.check_in)
    expect(page).to have_content 'Data de saída: ' + I18n.l(reservation.check_out)
    expect(page).to have_content 'Hóspedes: 2'
  end

  it 'and view details' do
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
    # Assert
    expect(page).to have_content 'Detalhes da reserva: ' + reservation.code
    expect(page).to have_content 'Quarto: Blue Room'
    expect(page).to have_content 'Data de entrada: ' + I18n.l(reservation.check_in)
    expect(page).to have_content 'Data de saída: ' + I18n.l(reservation.check_out)
    expect(page).to have_content 'Hóspedes: 2'
    expect(page).to have_content 'Valor total: R$ 800,00'
    expect(page).to have_content 'Status: Pendente'
    expect(page).to have_content 'Nome do hóspede: Gabriel'
    expect(page).to have_content 'E-mail do hóspede: gabriel@gmail.com'
  end
end
