require 'rails_helper'

describe 'Innkeeper checks out reservation' do
  include ActiveSupport::Testing::TimeHelpers
  
  it 'from reservation page' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: inn.inn_additional)
    PaymentMethod.create!(name: 'Dinheiro', inn_additional: inn.inn_additional)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200_00, inn: inn, status: :active)
    guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    guest.guest_user.update!(cpf: '12345678900')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    travel_to 6.days.from_now do
      reservation.active
    end
    # Act
    travel_to 10.days.from_now do
      login_as(innkeeper)
      visit root_path
      click_on 'Reservas'
      click_on 'Estadias Ativas'
      click_on reservation.code
      click_on 'Realizar CHECK-OUT'
    end
    # Assert
    expect(page).to have_content 'Confirmar CHECK-OUT da reserva: ' + reservation.code
  end
  
  it 'successfully' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: inn.inn_additional)
    PaymentMethod.create!(name: 'Dinheiro', inn_additional: inn.inn_additional)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200_00, inn: inn, status: :active)
    guest = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    guest.guest_user.update!(cpf: '12345678900')
    reservation = Reservation.create!(check_in: 6.days.from_now, check_out: 9.days.from_now, guests: 2, room: room, user: guest)
    travel_to 6.days.from_now do
      reservation.active
    end
    # Act
    travel_to 10.days.from_now do
      login_as(innkeeper)
      visit root_path
      click_on 'Reservas'
      click_on 'Estadias Ativas'
      click_on reservation.code
      click_on 'Realizar CHECK-OUT'
      select 'Dinheiro', from: 'Meio de pagamento'
      click_on 'Finalizar CHECK-OUT'
    end
    # Assert
    expect(page).to have_content 'Check-out realizado com sucesso!'
    expect(page).to have_content reservation.code
    expect(page).to have_content 'Data e Hora de Saída: ' + reservation.reload.additionals.datetime_check_out.strftime('%d/%m/%Y %H:%M')
    expect(page).not_to have_content 'Data de saída: ' + reservation.check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Status: Finalizada'
    expect(page).to have_content 'Valor Final: R$ 1000,00'
    expect(page).to have_content 'Meio de pagamento: Dinheiro'
    expect(page).not_to have_button 'Realizar CHECK-OUT'
    expect(current_path).to eq innkeeper_reservation_path(reservation)
  end
end