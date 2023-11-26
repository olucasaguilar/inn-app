require 'rails_helper'

describe 'Visitor view its reservations' do
  it 'and must be authenticated' do
    # Act
    visit root_path
    # Assert
    expect(page).not_to have_link('Minhas Reservas')
  end

  it 'and there are no reservations' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn, status: :active)
    Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 1, room: room)
    Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room)
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    # Assert
    expect(page).to have_content 'Reservas de Gabriel'
    expect(page).to have_content 'Você não possui reservas'
    expect(page).not_to have_content '2 hóspedes'
    expect(page).not_to have_content '1 hóspede'
  end

  it 'and dont see other users reservations' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn, status: :active)
    Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 1, room: room)
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC54321')
    Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    # Assert
    expect(page).to have_content 'Reservas de Gabriel'
    expect(page).to have_content 'Reserva: ABC54321'
    expect(page).to have_link 'Blue Room'
    expect(page).to have_content '2 hóspedes'
    expect(page).not_to have_content '1 hóspede'
  end

  it 'and view details of a reservation' do
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
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Blue Room'
    # Assert
    expect(page).to have_content 'Detalhes da Reserva'
    expect(page).to have_content 'Reserva: ABC12345'
    expect(page).to have_content 'Pousada: Pousada do Alemão'
    expect(page).to have_content 'Quarto: Blue Room'
    expect(page).to have_content 'Data de entrada: ' + I18n.l(reservation.check_in)
    expect(page).to have_content 'Data de saída: ' + I18n.l(reservation.check_out)
    expect(page).to have_content 'Valor da diária: R$ 200,00'
    expect(page).to have_content 'Valor total: R$ 600,00'
    expect(page).to have_content 'Quantidade de hóspedes: 2'
    expect(page).to have_content 'CPF do responsável: 12345678900'
    expect(page).to have_content 'Status: Pendente'
  end
end