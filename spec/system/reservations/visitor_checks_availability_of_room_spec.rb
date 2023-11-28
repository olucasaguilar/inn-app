require 'rails_helper'

describe 'Visitor checks availability of room' do
  it 'from home page' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 20000, inn: inn, status: :active)
    Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                 max_occupancy: 3, value: 30000, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    within('#room-2') do
      click_on 'RESERVAR'
    end
    # Assert
    expect(page).to have_content 'Verificar a disponibilidade do quarto: Suite Master'    
    expect(page).to have_content 'Detalhes do quarto'
    expect(page).to have_content 'Dimensão: 30 m²'
    expect(page).to have_content 'Ocupação máxima: 3 pessoas'
    expect(page).to have_content 'Valor da diária: R$ 300,00'
    expect(page).to have_content 'Banheiro: Não'
    expect(page).to have_content 'Sacada: Não'
    expect(page).to have_content 'Ar condicionado: Não'
    expect(page).to have_content 'TV: Não'
    expect(page).to have_content 'Guarda-roupa: Não'
    expect(page).to have_content 'Cofre: Não'
    expect(page).to have_content 'Acessibilidade: Não'
    
    expect(page).to have_field 'Data de entrada'
    expect(page).to have_field 'Data de saída'
    expect(page).to have_field 'Quantidade de hóspedes'
    expect(page).to have_button 'Verificar disponibilidade'
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
                 max_occupancy: 2, value: 150_00, inn: inn, status: :active)
    PricePeriod.create!(start_date: 2.days.from_now, end_date: 5.days.from_now, value: 100_00, room: room)
    Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 2, room: room, 
                        status: :canceled)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 2
    click_on 'Verificar disponibilidade'
    # # Assert
    expect(page).to have_content 'Verificar a disponibilidade do quarto: Blue Room'
    expect(page).to have_content 'Quarto disponível para reserva'
    expect(page).to have_content 'Valor total das diárias: R$ 400,00'
    expect(page).to have_link 'Prosseguir'
  end

  it 'and must fill in all fields' do# Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn, status: :active)
    # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: ''
    fill_in 'Data de saída', with: ''
    fill_in 'Quantidade de hóspedes', with: ''
    click_on 'Verificar disponibilidade'    
    # # Assert
    expect(page).to have_field 'Data de entrada'
    expect(page).not_to have_content 'Quarto disponível para reserva'
    expect(page).to have_content 'Data de entrada não pode ficar em branco'
    expect(page).to have_content 'Data de saída não pode ficar em branco'
    expect(page).to have_content 'Quantidade de hóspedes não pode ficar em branco'
  end

  it 'and there is no availability in the period' do
    # # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn, status: :active)
    Reservation.create!(check_in: 2.days.from_now, check_out: 5.days.from_now, guests: 2, room: room)
    # # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 3.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 4.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 2
    click_on 'Verificar disponibilidade'
    # # Assert
    expect(page).to have_field 'Data de entrada'
    expect(page).not_to have_content 'Quarto disponível para reserva'
    expect(page).to have_content 'O periodo informado está indisponível'    
  end

  it 'and there is no availability for the number of guests' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: innkeeper, status: :active)
    room = Room.create!(name: 'Blue Room', description: 'Quarto com vista para o mar', dimension: 20,
                 max_occupancy: 2, value: 200, inn: inn, status: :active)
    # # Act
    visit root_path
    click_on 'Pousada do Alemão'
    click_on 'RESERVAR'
    fill_in 'Data de entrada', with: 2.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Data de saída', with: 5.days.from_now.strftime('%d/%m/%Y')
    fill_in 'Quantidade de hóspedes', with: 3
    click_on 'Verificar disponibilidade'
    # Assert
    expect(page).to have_field 'Data de entrada'
    expect(page).not_to have_content 'Quarto disponível para reserva'
    expect(page).to have_content 'O quarto não comporta a quantidade de hóspedes informada'
  end
end  