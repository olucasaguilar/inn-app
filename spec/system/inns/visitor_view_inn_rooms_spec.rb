require 'rails_helper'

describe 'Visitor view inn rooms' do
  it 'and there are one rooms' do 
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: address, user: innkeeper, status: :active)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: innkeeper.inn, status: :inactive)
    Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                               max_occupancy: 3, value: 300, inn: innkeeper.inn, status: :active)

    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Quartos'
    expect(page).not_to have_content 'Quarto 1'
    expect(page).to have_content 'Suite Master'
  end

  it 'and there are multiple rooms' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: address, user: innkeeper, status: :active)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: innkeeper.inn, status: :active)
    Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                               max_occupancy: 3, value: 300, inn: innkeeper.inn, status: :inactive)
    Room.create!(name: 'Quarto 2', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: innkeeper.inn, status: :active)

    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Quartos'
    expect(page).to have_content 'Quarto 1'
    expect(page).not_to have_content 'Suite Master'
    expect(page).to have_content 'Quarto 2'
  end
  
  it 'and there are no rooms' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: address, user: innkeeper, status: :active)
    Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                               max_occupancy: 3, value: 300, inn: innkeeper.inn, status: :inactive)

    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).not_to have_content 'Suite Master'
    expect(page).to have_content 'Nenhum quarto disponível'
  end

  it 'successfully' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: address, user: innkeeper, status: :active)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: innkeeper.inn, status: :inactive)
    Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                               max_occupancy: 3, value: 300, inn: innkeeper.inn, status: :active)

    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Quartos'
    expect(page).not_to have_content 'Quarto 1'
    expect(page).to have_content 'Suite Master'
    expect(page).to have_content 'Suite com vista para o mar e varanda'
    expect(page).to have_content '30 m²'
    expect(page).to have_content '3 pessoas'
    expect(page).to have_content 'R$ 300,00'
    expect(page).to have_content 'Banheiro: Não'
    expect(page).to have_content 'Sacada: Não'
    expect(page).to have_content 'Ar condicionado: Não'
    expect(page).to have_content 'TV: Não'
    expect(page).to have_content 'Guarda-roupa: Não'
    expect(page).to have_content 'Cofre: Não'
    expect(page).to have_content 'Acessibilidade: Não'
  end
end
