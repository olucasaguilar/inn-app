require 'rails_helper'

describe 'Visitor view inn details' do
  it 'successfully' do
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

    # Act
    visit root_path
    click_on 'Pousada do Alemão'

    # Assert
    expect(page).to have_content 'Detalhes da Pousada'

    expect(page).to have_content 'Nome: Pousada do Alemão'
    expect(page).not_to have_content 'Razão social: Pousada do Alemão LTDA'
    expect(page).not_to have_content 'CNPJ: 12345678901234'
    expect(page).to have_content 'Telefone: 11999999999'
    expect(page).to have_content 'E-mail: pdalemao@gmail.com'

    expect(page).to have_content 'Rua: Rua dos Bobos, 115'
    expect(page).to have_content 'Bairro: Vila Madalena'
    expect(page).to have_content 'Cidade: São Paulo - SP'
    expect(page).to have_content 'CEP: 05412000'
    
    expect(page).to have_content 'Informações adicionais:'
    expect(page).to have_content 'Sem Descrição'
    expect(page).to have_content 'Sem Políticas'
    expect(page).to have_content 'Check-in:'
    expect(page).to have_content 'Check-out:'
    expect(page).to have_content 'Aceita Pets: Não'
  end

  it 'and must be an active inn' do
    # Arrange
    innkeeper = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                address: address, user: innkeeper, status: :inactive)

    # Act
    visit inn_path(inn)

    # Assert
    expect(current_path).to eq root_path
  end
end
