require 'rails_helper'

describe 'User sign up' do
  it 'as inn keeper successfully' do
    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Gabriel'
    select 'Sim', from: 'Dono de pousada'
    fill_in 'E-mail', with: 'gabriel@gmail.com'
    fill_in 'Senha', with: '654321'
    fill_in 'Confirme sua senha', with: '654321'
    click_on 'Criar Usuário'

    # Assert
    expect(page).to have_content 'Boas Vindas! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'Gabriel'
    expect(page).to have_content '(Proprietário)'
    expect(page).to have_button 'Sair'
    user = User.last
    expect(user.innkeeper?).to be true
  end
    
  context 'as guest' do
    it 'successfully' do
      # Act
      visit root_path
      click_on 'Entrar'
      click_on 'Criar conta'
      fill_in 'Nome', with: 'Pedro'
      select 'Não', from: 'Dono de pousada'
      fill_in 'E-mail', with: 'pedro@gmail.com'
      fill_in 'Senha', with: '123312'
      fill_in 'Confirme sua senha', with: '123312'
      click_on 'Criar Usuário'
  
      # Assert
      expect(page).to have_content 'Pedro'
      expect(page).to have_content '(Hóspede)'
      user = User.last
      expect(user.innkeeper?).to be false
    end

    context 'and adds CPF' do
      it 'right after it' do
        # Act
        visit root_path
        click_on 'Entrar'
        click_on 'Criar conta'
        fill_in 'Nome', with: 'Pedro'
        select 'Não', from: 'Dono de pousada'
        fill_in 'E-mail', with: 'pedro@gmail.com'
        fill_in 'Senha', with: '123312'
        fill_in 'Confirme sua senha', with: '123312'
        click_on 'Criar Usuário'
        # Assert
        expect(page).to have_content 'Cadastro de Hóspede'
        expect(page).to have_content 'Por favor, preencha os dados abaixo para continuar'
        expect(page).to have_field 'CPF'
      end

      it 'successfully' do
        # Act
        visit root_path
        click_on 'Entrar'
        click_on 'Criar conta'
        fill_in 'Nome', with: 'Pedro'
        select 'Não', from: 'Dono de pousada'
        fill_in 'E-mail', with: 'pedro@gmail.com'
        fill_in 'Senha', with: '123312'
        fill_in 'Confirme sua senha', with: '123312'
        click_on 'Criar Usuário'
        fill_in 'CPF', with: '12345678910'
        click_on 'Atualizar Usuário'
        # Assert
        expect(page).to have_content 'Boas Vindas! Você realizou seu registro com sucesso.'
        expect(page).not_to have_content 'Cadastro de Hóspede'
      end
      
      it 'and is mandatory' do
        # Act
        visit root_path
        click_on 'Entrar'
        click_on 'Criar conta'
        fill_in 'Nome', with: 'Pedro'
        select 'Não', from: 'Dono de pousada'
        fill_in 'E-mail', with: 'pedro@gmail.com'
        fill_in 'Senha', with: '123312'
        fill_in 'Confirme sua senha', with: '123312'
        click_on 'Criar Usuário'
        fill_in 'CPF', with: ''
        click_on 'Atualizar Usuário'
        # Assert
        expect(page).to have_content 'Cadastro de Hóspede'
        expect(page).to have_content 'CPF não pode ficar em branco'  
      end
    end
  end

  it 'and must fill all fields' do
    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    click_on 'Criar Usuário'

    # Assert
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end
end
