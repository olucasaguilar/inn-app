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
                      address: address, user: user)
    # Act
    visit new_inn_path
    # Assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Nome fantasia: Pousada do Alemão'
    expect(page).to have_content 'Razão social: Pousada do Alemão LTDA'
    expect(page).not_to have_field 'Nome fantasia'
    expect(page).not_to have_field 'Razão social'
  end

  it 'trying to edit someone else\'s payment methods' do
    user1 = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address1 = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn1 = Inn.create!(name: 'Pousada', social_name: 'Pousada do Alemão LTDA', cnpj: '12345678901234', 
                      phone: '11999999999', email: 'teste@gmail.com', address: address1, user: user1)
    PaymentMethod.create!(name: 'Cartão de crédito', additional_information: inn1.additional_information)
    # Arrange
    user = User.create!(name: 'Pedro', email: 'pedro@gmail.com', password: '654321', innkeeper: true)
    login_as(user)
    address = Address.new(street: 'Rua dos Tolos, 115', neighborhood: 'Vila Madarena', 
                          state: 'PR', city: 'Paulo', zip_code: '12312312')
    inn = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Russo LTDA', 
                      cnpj: '3123123123123123', phone: '22222222222', email: 'pdrusso@gmail.com', 
                      address: address, user: user)
    # Act
    visit edit_payment_method_path(PaymentMethod.last)
    expect(current_path).to eq my_inn_path
  end
end