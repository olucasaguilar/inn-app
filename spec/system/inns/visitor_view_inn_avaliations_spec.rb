require 'rails_helper'

describe 'Visitor view inn avaliations' do
  include ActiveSupport::Testing::TimeHelpers

  it 'and see the three last avaliations' do
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
    reservation_001 = Reservation.create!(check_in: 2.days.from_now, check_out: 3.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_002 = Reservation.create!(check_in: 4.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_003 = Reservation.create!(check_in: 6.days.from_now, check_out: 7.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_004 = Reservation.create!(check_in: 8.days.from_now, check_out: 9.days.from_now, guests: 2,
                                          room: room, user: guest)
    travel_to 2.days.from_now do
      reservation_001.active
    end
    travel_to 3.days.from_now do
      reservation_001.finished
    end
    travel_to 4.days.from_now do
      reservation_002.active
    end
    travel_to 5.days.from_now do
      reservation_002.finished
    end
    travel_to 6.days.from_now do
      reservation_003.active
    end
    travel_to 7.days.from_now do
      reservation_003.finished
    end
    travel_to 8.days.from_now do
      reservation_004.active
    end
    travel_to 9.days.from_now do
      reservation_004.finished
    end
    review_001 = Review.create!(rating: 5, comment: 'Ótima pousada', reservation: reservation_001)
    review_002 = Review.create!(rating: 3, comment: 'Gostei!!!!', reservation: reservation_002)
    review_003 = Review.create!(rating: 3, comment: 'Muiiito bom', reservation: reservation_003)
    review_004 = Review.create!(rating: 1, comment: 'toptoptoptop', reservation: reservation_004)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Detalhes da Pousada'

    expect(page).to have_content 'Avaliações'    
    expect(page).not_to have_content 'Não há avaliações no momento.'
    expect(page).not_to have_content 'Reserva: ' + reservation_001.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_001.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).not_to have_content 'Comentário: Ótima pousada'
    expect(page).not_to have_content 'Nota: 5'

    expect(page).to have_content 'Hóspede: Gabriel'
    expect(page).to have_content 'Reserva: ' + reservation_002.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_002.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: Gostei!!!!'
    expect(page).to have_content 'Nota: 3'

    expect(page).to have_content 'Reserva: ' + reservation_003.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_003.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: Muiiito bom'
    expect(page).to have_content 'Nota: 3'

    expect(page).to have_content 'Reserva: ' + reservation_004.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_004.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: toptoptoptop'
    expect(page).to have_content 'Nota: 1'
  end

  it 'and there is no avaliations' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    # Assert
    expect(page).to have_content 'Detalhes da Pousada'
    expect(page).to have_content 'Não há avaliações no momento.'
  end

  it 'and see all avaliations' do
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
    reservation_001 = Reservation.create!(check_in: 2.days.from_now, check_out: 3.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_002 = Reservation.create!(check_in: 4.days.from_now, check_out: 5.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_003 = Reservation.create!(check_in: 6.days.from_now, check_out: 7.days.from_now, guests: 2, 
                                          room: room, user: guest)
    reservation_004 = Reservation.create!(check_in: 8.days.from_now, check_out: 9.days.from_now, guests: 2,
                                          room: room, user: guest)
    travel_to 2.days.from_now do
      reservation_001.active
    end
    travel_to 3.days.from_now do
      reservation_001.finished
    end
    travel_to 4.days.from_now do
      reservation_002.active
    end
    travel_to 5.days.from_now do
      reservation_002.finished
    end
    travel_to 6.days.from_now do
      reservation_003.active
    end
    travel_to 7.days.from_now do
      reservation_003.finished
    end
    travel_to 8.days.from_now do
      reservation_004.active
    end
    travel_to 9.days.from_now do
      reservation_004.finished
    end
    review_001 = Review.create!(rating: 5, comment: 'Ótima pousada', reservation: reservation_001)
    review_002 = Review.create!(rating: 3, comment: 'Gostei!!!!', reservation: reservation_002)
    review_003 = Review.create!(rating: 3, comment: 'Muiiito bom', reservation: reservation_003)
    review_004 = Review.create!(rating: 1, comment: 'toptoptoptop', reservation: reservation_004)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'Ver todas as avaliações'
    # Assert
    expect(page).to have_content 'Todas as Avaliações de: Pousada do Alemão'
    expect(page).to have_content 'Reserva: ' + reservation_001.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_001.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: Ótima pousada'
    expect(page).to have_content 'Nota: 5'

    expect(page).to have_content 'Hóspede: Gabriel'
    expect(page).to have_content 'Reserva: ' + reservation_002.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_002.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: Gostei!!!!'
    expect(page).to have_content 'Nota: 3'

    expect(page).to have_content 'Reserva: ' + reservation_003.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_003.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: Muiiito bom'
    expect(page).to have_content 'Nota: 3'

    expect(page).to have_content 'Reserva: ' + reservation_004.check_in.strftime('%d/%m/%Y') + ' - ' + reservation_004.additionals.datetime_check_out.strftime('%d/%m/%Y')
    expect(page).to have_content 'Comentário: toptoptoptop'
    expect(page).to have_content 'Nota: 1'
  end
end
