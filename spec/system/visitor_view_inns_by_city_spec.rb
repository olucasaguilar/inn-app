require 'rails_helper'

describe 'Visitor view inns by city' do
  it 'from home page' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Bauru', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)

    # Act
    visit root_path

    # Assert
    within 'div#cities' do
      expect(page).to have_link 'São Paulo'
      expect(page).to have_link 'Bauru'
    end
  end

  it 'successfuly' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Bauru', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)
    third_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'SP', city: 'São Paulo', zip_code: '12312312')
    Inn.create!(name: 'Pousada Top', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: third_address, user: innkeeper, status: :active)

    # Act
    visit root_path
    click_on 'São Paulo'
    
    # Assert
    expect(page).to have_content 'Pousadas em São Paulo'
    expect(page).to have_link 'Pousada Top'
    expect(page).to have_link 'Pousada do Alemão'
  end

  it 'and view details' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    first_address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: first_address, user: innkeeper, status: :active)
    second_address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                                 state: 'PR', city: 'Bauru', zip_code: '12312312')
    Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                address: second_address, user: innkeeper, status: :active)

    # Act
    visit root_path
    click_on 'São Paulo'
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Detalhes da Pousada'
    expect(page).to have_content 'Nome: Pousada do Alemão'
  end
end
