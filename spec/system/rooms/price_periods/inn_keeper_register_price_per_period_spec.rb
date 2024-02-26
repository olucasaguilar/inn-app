require 'rails_helper'

describe 'Inn keeper register a rooms prices per period page' do
  it 'successfully' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 20000, inn: inn)
    # Act
    login_as(user)
    visit room_path(room)
    click_on 'Preços por período'
    click_on 'Cadastrar novo preço'
    fill_in 'Data de início', with: '01/01/2021'
    fill_in 'Data de término', with: '10/01/2021'
    fill_in 'Valor', with: '25000'
    click_on 'Criar Preço por Período'
    # Assert
    expect(page).to have_content 'Preço por período cadastrado com sucesso'
    expect(page).to have_content 'Preços por período'
    expect(page).to have_content '01/01/2021 a 10/01/2021'
    expect(page).to have_content 'R$ 250,00'
  end

  context 'unsuccessfully' do
    it 'and dates are inside a period already registered' do
      # Arrange
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 200, inn: inn)
      PricePeriod.create!(start_date: "2015-01-01", end_date: "2015-01-10", value: 100, room: room)
      # Act
      login_as(user)
      visit room_path(room)
      click_on 'Preços por período'
      click_on 'Cadastrar novo preço'
      fill_in 'Data de início', with: '03/01/2015'
      fill_in 'Data de término', with: '20/01/2015'
      fill_in 'Valor', with: '350'
      click_on 'Criar Preço por Período'
      # Assert
      expect(page).to have_content 'Preço por período não cadastrado'
      expect(page).to have_content 'Data de início já está dentro de um período cadastrado'
    end

    it 'and start date is greater than end date' do
      # Arrange
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 200, inn: inn)
      # Act
      login_as(user)
      visit room_path(room)
      click_on 'Preços por período'
      click_on 'Cadastrar novo preço'
      fill_in 'Data de início', with: '25/01/2015'
      fill_in 'Data de término', with: '20/01/2015'
      fill_in 'Valor', with: '350'
      click_on 'Criar Preço por Período'
      # Assert
      expect(page).to have_content 'Preço por período não cadastrado'
      expect(page).to have_content 'Data de início deve ser menor que a data final'
    end

    it 'and must fill in all fields' do
      # Arrange
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                            state: 'SP', city: 'São Paulo', zip_code: '05412000')
      inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                        cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                        address: address, user: user)
      room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                          max_occupancy: 2, value: 200, inn: inn)
      # Act
      login_as(user)
      visit room_path(room)
      click_on 'Preços por período'
      click_on 'Cadastrar novo preço'
      fill_in 'Data de início', with: ''
      fill_in 'Data de término', with: ''
      fill_in 'Valor', with: ''
      click_on 'Criar Preço por Período'
      # Assert
      expect(page).to have_content 'Preço por período não cadastrado'
      expect(page).to have_content 'Data de início não pode ficar em branco'
      expect(page).to have_content 'Data de término não pode ficar em branco'
      expect(page).to have_content 'Valor não é um número'
    end
  end
end