require 'rails_helper'

describe 'Visitor books a room' do
  it 'and must be authenticated' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 3, value: 20000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'
    click_on 'Prosseguir'
    # # Assert
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    expect(page).to have_link 'Entrar'
    expect(page).to have_link 'Criar conta'
  end
  
  it 'and keeps in the reservation page after authentication' do
    # Arrange
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 3, value: 20000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'    
    click_on 'Prosseguir'    
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Pedro'
    select 'Não', from: 'Dono de pousada'
    fill_in 'E-mail', with: 'pedro@gmail.com'
    fill_in 'Senha', with: '123312'
    fill_in 'Confirme sua senha', with: '123312'
    click_on 'Criar Usuário'
    fill_in 'CPF', with: '12345678910'
    click_on 'Atualizar Usuário'
    # Assert
    expect(current_path).not_to eq root_path
    expect(page).to have_content 'Resumo da reserva'
  end
  
  it 'and there is a summary of the reservation' do
    # Arrange
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    inn.inn_additional.update!(check_in: '14:00', check_out: '12:00')
    PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: inn.inn_additional)
    PaymentMethod.create!(name: 'Boleto bancário', inn_additional: inn.inn_additional)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 3, value: 20000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'    
    login_as(user)
    click_on 'Prosseguir'
    # Assert
    expect(page).to have_content 'Resumo da reserva'
    expect(page).to have_content 'Pousada: Pousada do Alemão'
    expect(page).to have_content 'Quarto: Blue Room'
    expect(page).to have_content "Check-in: #{2.days.from_now.strftime('%d/%m/%Y')} às 14:00"
    expect(page).to have_content "Check-out: #{5.days.from_now.strftime('%d/%m/%Y')} às 12:00"
    expect(page).to have_content 'Valor total: R$ 600,00'
    expect(page).to have_content 'Formas de pagamento'
    expect(page).to have_content 'Cartão de crédito'
    expect(page).to have_content 'Boleto bancário'
    expect(page).to have_button 'Confirmar reserva'
  end

  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 3, value: 20000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'    
    login_as(user)
    click_on 'Prosseguir'
    click_on 'Confirmar reserva'
    # Assert
    expect(page).to have_content 'Reserva confirmada com sucesso!'
    reservation = Reservation.last
    expect(reservation.user).to eq user
  end

  it 'and the availability changed while the user was booking' do
    # Arrange
    user = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
    user.guest_user.update!(cpf: '12345678900')
    user_02 = User.create!(name: 'Peter', email: 'peter@gmail.com', password: '123456', innkeeper: false)
    user_02.guest_user.update!(cpf: '98765432100')
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 3, value: 20000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'    
    login_as(user)
    click_on 'Prosseguir'
    Reservation.create!(room: room, user: user_02, check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 3)
    click_on 'Confirmar reserva'
    # Assert
    expect(current_path).to eq new_inn_room_reservation_path(inn, room)
    expect(page).to have_content 'Não foi possível confirmar a reserva' 
  end
end