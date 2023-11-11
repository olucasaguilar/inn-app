require 'rails_helper'

describe 'Visitor search inn' do
  it 'from homepage' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within('header nav') do
      expect(page).to have_field('Buscar Pousadas')
      expect(page).to have_button('Buscar')
    end
  end

  it 'and find results by the city' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    third_address = Address.new(street: 'Avenida das Flores, 500', neighborhood: 'Jardim Primavera',
                                state: 'RJ', city: 'Rio de Janeiro', zip_code: '22334455')
    Inn.create!(name: 'Hotel Primavera', social_name: 'Hotel Primavera LTDA',
                cnpj: '98765432109876', phone: '2122223333', email: 'hotelprimavera@example.com',
                address: third_address, user: innkeeper, status: :active)
    
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'Paulo'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: 'Paulo'"
    expect(page).to have_content '2 pousadas encontradas'
    expect(page).to have_link 'Pousada do Alemão'
    expect(page).to have_link 'Pousada do Russo'
    expect(page).not_to have_link 'Hotel Primavera'
  end

  it 'and find just one result' do
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'São Paulo'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: 'São Paulo'"
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Alemão'
    expect(page).not_to have_link 'Pousada do Russo'
  end

  it 'and find results by the inn name' do
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'Alemão'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: 'Alemão'"
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Alemão'
    expect(page).not_to have_link 'Pousada do Russo'
  end

  it 'and find results by the inn neighborhood' do
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'Madarena'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: 'Madarena'"
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Russo'
    expect(page).not_to have_link 'Pousada do Alemão'
  end

  it 'and find three results with the same term in different fields' do
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada Alemão', social_name: 'Pousada Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'São Alemão', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    third_address = Address.new(street: 'Avenida das Flores, 500', neighborhood: 'Jardim Alemão',
                                state: 'RJ', city: 'Rio de Janeiro', zip_code: '22334455')
    Inn.create!(name: 'Hotel Primavera', social_name: 'Hotel Primavera LTDA',
                cnpj: '98765432109876', phone: '2122223333', email: 'hotelprimavera@example.com',
                address: third_address, user: innkeeper, status: :active)
    
    # Act
    visit root_path
    fill_in 'Buscar Pousadas', with: 'Alemão'
    click_on 'Buscar'
  
    # Assert
    expect(page).to have_content "Resultados da Busca por: 'Alemão'"
    expect(page).to have_content '3 pousadas encontradas'
    expect(page).to have_link 'Pousada Alemão'
    expect(page).to have_link 'Pousada do Russo'
    expect(page).to have_link 'Hotel Primavera'
  end  
end