require 'rails_helper'

# dono de pousada edita pousada
describe 'Inn keeper change inn status' do
  it 'to active' do
    # Arrange
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    # Act
    visit my_inn_path
    expect(page).to have_content 'Status: Inativa'
    click_on 'Ativar'
    # Assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Status atualizado com sucesso'
    expect(page).to have_content 'Status: Ativa'
    expect(page).not_to have_content 'Ativar'
  end

  it 'to inactive' do
    # Arrange
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    inn.active!
    # Act
    visit my_inn_path
    expect(page).to have_content 'Status: Ativa'
    click_on 'Inativar'
    # Assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Status atualizado com sucesso'
    expect(page).to have_content 'Status: Inativa'
    expect(page).not_to have_content 'Inativar'
  end
end