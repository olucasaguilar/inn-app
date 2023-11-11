require 'rails_helper'

describe 'Inn keeper register inn' do  
  context 'with required fields' do
    it 'successfully' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      # Act
      login_as(user)
      visit new_inn_path

      fill_in 'Nome fantasia', with: 'Pousada do Alemão'
      fill_in 'Razão social', with: 'Pousada do Alemão LTDA'
      fill_in 'CNPJ', with: '12345678901234'
      fill_in 'Telefone', with: '11999999999'
      fill_in 'E-mail', with: 'pdalemao@gmail.com'

      fill_in 'Rua', with: 'Rua dos Bobos, 115'
      fill_in 'Bairro', with: 'Vila Madalena'
      fill_in 'Estado', with: 'SP'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'CEP', with: '05412000'

      fill_in 'Check-in', with: '14:03'
      fill_in 'Check-out', with: '12:00'

      click_on 'Criar Pousada'
      # Assert
      expect(current_path).to eq my_inn_path
      expect(page).to have_content 'Pousada cadastrada com sucesso'

      expect(page).to have_content 'Nome fantasia: Pousada do Alemão'
      expect(page).to have_content 'Razão social: Pousada do Alemão LTDA'
      expect(page).to have_content 'CNPJ: 12345678901234'
      expect(page).to have_content 'Telefone: 11999999999'
      expect(page).to have_content 'E-mail: pdalemao@gmail.com'

      expect(page).to have_content 'Rua: Rua dos Bobos, 115'
      expect(page).to have_content 'Bairro: Vila Madalena'
      expect(page).to have_content 'Cidade: São Paulo - SP'
      expect(page).to have_content 'CEP: 05412000'

      expect(page).to have_content 'Check-in: 14:03'
      expect(page).to have_content 'Check-out: 12:00'
    end
    
    it 'and must fill all required fields' do
      user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
      login_as(user)
      # Act
      visit new_inn_path

      fill_in 'Nome fantasia', with: ''
      fill_in 'Razão social', with: ''
      fill_in 'CNPJ', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'E-mail', with: ''

      fill_in 'Rua', with: ''
      fill_in 'Bairro', with: ''
      fill_in 'Estado', with: ''
      fill_in 'Cidade', with: ''
      fill_in 'CEP', with: ''

      fill_in 'Check-in', with: ''
      fill_in 'Check-out', with: ''

      click_on 'Criar Pousada'
      # Assert
      expect(page).to have_content 'Pousada não cadastrada'
      expect(page).not_to have_content 'Pousada cadastrada com sucesso'
      
      expect(page).to have_content 'Nome fantasia não pode ficar em branco'
      expect(page).to have_content 'Razão social não pode ficar em branco'
      expect(page).to have_content 'CNPJ não pode ficar em branco'
      expect(page).to have_content 'Telefone não pode ficar em branco'
      expect(page).to have_content 'E-mail não pode ficar em branco'

      expect(page).to have_content 'Rua não pode ficar em branco'
      expect(page).to have_content 'Bairro não pode ficar em branco'
      expect(page).to have_content 'Estado não pode ficar em branco'
      expect(page).to have_content 'Cidade não pode ficar em branco'
      expect(page).to have_content 'CEP não pode ficar em branco'

      expect(page).to have_content 'Check-in não pode ficar em branco'
      expect(page).to have_content 'Check-out não pode ficar em branco'

      expect(Inn.count).to eq 0
    end
  end

  it 'and before can\'t access root_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    login_as(user)
    visit root_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).to have_field 'Nome fantasia'
  end
end