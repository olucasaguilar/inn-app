require 'rails_helper'

describe 'User authenticate' do
  it 'successfully' do
    # Arrange
    User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    visit root_path
    click_on 'Entrar'
    within 'h2' do
      expect(page).to have_content 'Entrar'
    end
    within 'form#new_user' do
      fill_in 'E-mail', with: 'lucas@gmail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within 'nav' do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Lucas'
    end
  end

  it 'with invalid data' do
    # Arrange
    User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'lucas@gmail.com'
      fill_in 'Senha', with: ''
      click_on 'Entrar'
    end
    # Assert
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
  end

  it 'and sign out' do
    # Arrange
    User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    # Act
    visit root_path
    click_on 'Entrar'
    within 'form#new_user' do
      fill_in 'E-mail', with: 'lucas@gmail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end
    click_on 'Sair'
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
  end
end
