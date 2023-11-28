require 'rails_helper'

describe 'Visitor avaliate reservations' do
  include ActiveSupport::Testing::TimeHelpers
  
  it 'from reservation page' do
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
    travel_to 6.days.from_now do
      reservation.active
    end
    travel_to 10.days.from_now do
      reservation.finished
    end
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Blue Room'
    # Assert
    expect(page).to have_content 'Detalhes da Reserva'
    expect(page).to have_content 'Status: Finalizada'
    expect(page).to have_content 'Avaliar Estadia'
  end
  
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
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: user)
    travel_to 6.days.from_now do
      reservation.active
    end
    travel_to 10.days.from_now do
      reservation.finished
    end
    # Act
    login_as(user)
    visit root_path
    click_on 'Minhas Reservas'
    click_on 'Blue Room'
    click_on 'Avaliar Estadia'
    fill_in 'Nota', with: 4
    fill_in 'Comentário', with: 'Ótima estadia'
    click_on 'Enviar Avaliação'
    # Assert
    expect(page).to have_content 'Avaliação enviada com sucesso'
    expect(current_path).to eq inn_room_reservation_path(inn, room, reservation)
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Ótima estadia'    
    expect(page).not_to have_content 'Avaliar Estadia'
  end
end
