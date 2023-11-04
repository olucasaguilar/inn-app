require 'rails_helper'

describe 'Inn keeper gets blocked' do
  it 'trying to access new_inn_path again' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    # Act
    visit new_inn_path
    # Assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Nome fantasia: Pousada do Alemão'
    expect(page).to have_content 'Razão social: Pousada do Alemão LTDA'
    expect(page).not_to have_field 'Nome fantasia'
    expect(page).not_to have_field 'Razão social'
  end

  it 'trying to access my_inn_path without an inn' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    # Act
    visit my_inn_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).not_to have_content 'Nome fantasia:'
    expect(page).not_to have_content 'Razão social:'
    expect(page).to have_field 'Nome fantasia'
    expect(page).to have_field 'Razão social'    
  end
end