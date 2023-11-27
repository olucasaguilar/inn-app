require 'rails_helper'

describe 'Visitor cancel its reservation' do
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
    Reservation.create!(check_in: 9.days.from_now, check_out: 12.days.from_now, guests: 2, room: room, user: user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Blue Room'
    click_on 'CANCELAR'
    # Assert
    expect(page).to have_content 'Reserva cancelada com sucesso'
    expect(page).to have_content 'Status: Cancelado'
    expect(page).not_to have_content 'Status: Pendente'
    expect(page).not_to have_button 'CANCELAR'
  end

  it 'unsuccessfully if it has passed 7 days' do
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
    Reservation.create!(check_in: 12.days.from_now, check_out: 15.days.from_now, guests: 2, room: room, user: user)
    # Act
    time = ''
    travel_to(7.days.from_now) do
      login_as(user)
      visit root_path
      click_on 'Minhas Reservas'
      click_on 'Blue Room'
      click_on 'CANCELAR'
    end
    # Assert
    expect(page).to have_content 'Não é possível cancelar uma reserva com menos de 7 dias antes do check-in'
    expect(page).to have_content 'Status: Pendente'
    expect(page).not_to have_content 'Status: Cancelado'
  end
end
