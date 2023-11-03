require 'rails_helper'

# dono de pousada edita pousada
describe 'Inn keeper edit inn' do
  it 'successfully' do
    # Arrange
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    # Act
    visit my_inn_path
    click_on 'Editar'

    expect(page).to have_content 'Editar Pousada'
    expect(page).to have_field 'Nome fantasia', with: 'Pousada do Alemão'
    expect(page).to have_field 'Razão social', with: 'Pousada do Alemão LTDA'
    expect(page).to have_field 'CNPJ', with: '12345678901234'
    expect(page).to have_field 'Telefone', with: '11999999999'
    expect(page).to have_field 'E-mail', with: 'pdalemao@gmail.com'

    fill_in 'Nome fantasia', with: 'Pousada do Amigo do Alemão'
    fill_in 'Cidade', with: 'Apucarana'
    click_on 'Atualizar Pousada'
    # Assert
    expect(current_path).to eq my_inn_path
    expect(page).to have_content 'Pousada atualizada com sucesso'
    expect(page).to have_content 'Nome fantasia: Pousada do Amigo do Alemão'
    expect(page).to have_content 'Cidade: Apucarana - SP'
  end

  it 'and must fill all required fields' do
    # Arrange
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    # Act
    visit my_inn_path
    click_on 'Editar'

    fill_in 'Nome fantasia', with: ''
    fill_in 'Razão social', with: ''
    fill_in 'Cidade', with: ''    
    click_on 'Atualizar Pousada'
    # Assert
    expect(page).not_to have_content 'Pousada atualizada com sucesso'
    expect(page).to have_content 'Pousada não atualizada'
    expect(page).to have_content 'Nome fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão social não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
  end

  it 'and add additional informations' do
    address = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', 
                          state: 'SP', city: 'São Paulo', zip_code: '05412000')
    inn = Inn.create!(name: 'Pousada do Alemão', social_name: 'Pousada do Alemão LTDA', 
                      cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                      address: address)
    visit my_inn_path
    expect(page).to have_content 'Informações adicionais:'
    expect(page).to have_content 'Sem Descrição'
    expect(page).to have_content 'Sem Políticas'
    expect(page).to have_content 'Sem Horário de Check-in'
    expect(page).to have_content 'Sem Horário de Check-out'
    expect(page).to have_content 'Aceita Pets: Não'
    click_on 'Editar Informações Adicionais'

    expect(page).to have_content 'Editar Informações Adicionais'
    fill_in 'Descrição', with: 'Pousada do Alemão é uma pousada muito boa'
    fill_in 'Políticas', with: 'Não aceitamos som alto'
    fill_in 'Check-in', with: '14:00'
    fill_in 'Check-out', with: '12:00'
    page.check('pet')
    click_on 'Atualizar Informações Adicionais'    

    expect(page).to have_content 'Informações adicionais atualizadas com sucesso'
    expect(page).to have_content 'Descrição: Pousada do Alemão é uma pousada muito boa'
    expect(page).to have_content 'Políticas: Não aceitamos som alto'
    expect(page).to have_content 'Check-in: 14:00'
    expect(page).to have_content 'Check-out: 12:00'
    expect(page).to have_content 'Aceita Pets: Sim'
  end
end
