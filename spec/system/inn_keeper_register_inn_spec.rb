require 'rails_helper'

describe 'Inn keeper register inn' do
  context 'with required fields' do
    it 'successfully' do
      # Act
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

      click_on 'Criar Pousada'
      # Assert
      expect(page).to have_content 'Pousada cadastrada com sucesso'

      last_inn = Inn.last        
      expect(last_inn.name).to eq 'Pousada do Alemão'
      expect(last_inn.social_name).to eq 'Pousada do Alemão LTDA'
      expect(last_inn.cnpj).to eq '12345678901234'
      expect(last_inn.phone).to eq '11999999999'
      expect(last_inn.email).to eq 'pdalemao@gmail.com'

      expect(last_inn.address.street).to eq 'Rua dos Bobos, 115'
      expect(last_inn.address.neighborhood).to eq 'Vila Madalena'
      expect(last_inn.address.state).to eq 'SP'
      expect(last_inn.address.city).to eq 'São Paulo'
      expect(last_inn.address.zip_code).to eq '05412000'
    end
    
    it 'and must fill all required fields' do
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

      expect(Inn.count).to eq 0
    end
  end
  
  context 'with optional fields' do
    it 'successfully' do
      # Act
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

      click_on 'Criar Pousada'
      # Assert
      expect(page).to have_content 'Pousada cadastrada com sucesso'

      last_inn = Inn.last        
      expect(last_inn.name).to eq 'Pousada do Alemão'
      expect(last_inn.social_name).to eq 'Pousada do Alemão LTDA'
      expect(last_inn.cnpj).to eq '12345678901234'
      expect(last_inn.phone).to eq '11999999999'
      expect(last_inn.email).to eq 'pdalemao@gmail.com'
      expect(last_inn.address.street).to eq 'Rua dos Bobos, 115'
      expect(last_inn.address.neighborhood).to eq 'Vila Madalena'
      expect(last_inn.address.state).to eq 'SP'
      expect(last_inn.address.city).to eq 'São Paulo'
      expect(last_inn.address.zip_code).to eq '05412000'
    end
  end
end