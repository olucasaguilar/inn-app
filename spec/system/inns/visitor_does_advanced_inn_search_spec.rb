require 'rails_helper'

describe 'Visitor does advanced inn search' do
  it 'from homepage' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within 'header nav' do
      expect(page).to have_link 'Busca Avançada'
    end
  end

  it 'and view the search form' do
    # Arrange
    
    # Act
    visit root_path
    click_on 'Busca Avançada'

    # Assert
    expect(page).to have_content 'Busca Avançada'
    expect(page).to have_field 'Aceita pets'
    expect(page).to have_field 'Banheiro'
    expect(page).to have_field 'Varanda'
    expect(page).to have_field 'Ar condicionado'
    expect(page).to have_field 'TV'
    expect(page).to have_field 'Guarda-roupa'
    expect(page).to have_field 'Cofre'
    expect(page).to have_field 'Acessibilidade'
  end

  it 'and the form filled options remain' do
    # Arrange

    # Act
    visit root_path
    click_on 'Busca Avançada'
    check 'Banheiro'
    within 'div#advanced_search' do
      click_on 'Buscar'
    end

    # Assert
    expect(page).to have_field 'Banheiro', checked: true
  end

  it 'and finds one result' do
    # Arrange
    first_innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
    first_inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: first_address, user: first_innkeeper, status: :active)
    first_room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: first_inn, bathroom: true, status: :active)
    
    second_innkeeper = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '123456', innkeeper: true)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    second_inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '3123123123123123', phone: '22222222222', email: 'pdalemao@gmail.com', 
                            address: second_address, user: second_innkeeper, status: :active)
    second_room = Room.create!(name: 'Quarto Luxo', description: 'Quarto luxuoso com jacuzzi', dimension: 25,
                              max_occupancy: 2, value: 400, inn: second_inn, bathroom: true, status: :inactive)
    # Act
    visit root_path
    click_on 'Busca Avançada'
    check 'Banheiro'
    within 'div#advanced_search' do
      click_on 'Buscar'
    end

    # Assert
    expect(page).to have_content 'Resultado da busca avançada'
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Russo'
    expect(page).not_to have_link 'Pousada do Alemão'
    expect(page).to have_content 'Nota Média: Sem avaliações'
  end

  it 'and finds multiple results' do
    # Arrange
    first_innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
    first_inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: first_address, user: first_innkeeper, status: :active)
    first_room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: first_inn, wardrobe: true, tv: true, status: :active)
    
    second_innkeeper = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '123456', innkeeper: true)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    second_inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '3123123123123123', phone: '22222222222', email: 'pdalemao@gmail.com', 
                            address: second_address, user: second_innkeeper, status: :active)
    second_room = Room.create!(name: 'Quarto Luxo', description: 'Quarto luxuoso com jacuzzi', dimension: 25,
                              max_occupancy: 2, value: 400, inn: second_inn, wardrobe: true, tv: false, status: :active)

    third_innkeeper = User.create!(name: 'Rafael', email: 'rafael@gmail.com', password: '123456', innkeeper: true)
    third_address = Address.new(street: 'Rua Benjamin, 115', neighborhood: 'Vila Rafa', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    third_inn = Inn.create!(name: 'Pousada do Rafa', social_name: 'Pousada do Rafa LTDA', 
                            cnpj: '3123123123123123', phone: '22222222222', email: 'pdalemao@gmail.com', 
                            address: third_address, user: third_innkeeper, status: :active)
    third_room = Room.create!(name: 'Quarto Roxo', description: 'Quarto roxoso', dimension: 25,
                              max_occupancy: 2, value: 400, inn: third_inn,  wardrobe: true, tv: true, status: :active)
    # Act
    visit root_path
    click_on 'Busca Avançada'
    check 'TV'
    check 'Guarda-roupa'
    within 'div#advanced_search' do
      click_on 'Buscar'
    end

    # Assert
    expect(page).to have_content 'Resultado da busca avançada'
    expect(page).to have_content '2 pousadas encontradas'
    expect(page).to have_link 'Pousada do Russo'
    expect(page).to have_link 'Pousada do Rafa'
    expect(page).not_to have_link 'Pousada do Alemão'
  end

  it 'and finds no results' do
    # Arrange
    first_innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                                state: 'SP', city: 'São Paulo', zip_code: '05412000')
    first_inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                            address: first_address, user: first_innkeeper, status: :active)
    first_room = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                              max_occupancy: 2, value: 200, inn: first_inn, bathroom: true, status: :active)
    
    second_innkeeper = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '123456', innkeeper: true)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    second_inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                            cnpj: '3123123123123123', phone: '22222222222', email: 'pdalemao@gmail.com', 
                            address: second_address, user: second_innkeeper, status: :active)
    second_room = Room.create!(name: 'Quarto Luxo', description: 'Quarto luxuoso com jacuzzi', dimension: 25,
                              max_occupancy: 2, value: 400, inn: second_inn, bathroom: true, status: :active)
    # Act
    visit root_path
    click_on 'Busca Avançada'
    check 'Varanda'
    within 'div#advanced_search' do
      click_on 'Buscar'
    end

    # Assert
    expect(page).to have_content 'Resultado da busca avançada'
    expect(page).to have_content '0 pousadas encontradas'
    expect(page).not_to have_link 'Pousada do Russo'
    expect(page).not_to have_link 'Pousada do Alemão'
  end
end