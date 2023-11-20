require 'rails_helper'

describe 'Inn keeper view room details' do
  it 'from my_inn_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                        max_occupancy: 2, value: 200, inn: inn)
    # Act
    login_as(user)
    visit my_inn_path
    click_on 'Quarto 1'
    # Assert
    expect(page).to have_content 'Detalhes do quarto: Quarto 1'
  end

  it 'with mandatory fields' do
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
    # Assert
    expect(page).to have_content 'Quarto 1'
    expect(page).to have_content 'Descrição: Quarto com vista para o mar'
    expect(page).to have_content 'Dimensão: 20 m²'
    expect(page).to have_content 'Ocupação máxima: 2 pessoas'
    expect(page).to have_content 'Valor da diária: R$ 200,00'
    expect(page).to have_content 'Banheiro: Não'
    expect(page).to have_content 'Sacada: Não'
    expect(page).to have_content 'Ar condicionado: Não'
    expect(page).to have_content 'TV: Não'
    expect(page).to have_content 'Guarda-roupa: Não'
    expect(page).to have_content 'Cofre: Não'
    expect(page).to have_content 'Acessibilidade: Não'
  end

  it 'with optional fields' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address, user: user)
    room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                max_occupancy: 2, value: 200, inn: inn, bathroom: true, balcony: true,
                air_conditioning: true, tv: true, wardrobe: true, safe: true, accessible: true)
    # Act
    login_as(user)
    visit room_path(room)
    # Assert
    expect(page).to have_content 'Banheiro: Sim'
    expect(page).to have_content 'Sacada: Sim'
    expect(page).to have_content 'Ar condicionado: Sim'
    expect(page).to have_content 'TV: Sim'
    expect(page).to have_content 'Guarda-roupa: Sim'
    expect(page).to have_content 'Cofre: Sim'
    expect(page).to have_content 'Acessibilidade: Sim'
  end
end
