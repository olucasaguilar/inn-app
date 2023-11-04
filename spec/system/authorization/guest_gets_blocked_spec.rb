require 'rails_helper'

describe 'Guest gets blocked' do
  it 'trying to access new_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    # Act
    login_as(user)
    visit new_inn_path
    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Nome fantasia:'
    expect(page).not_to have_content 'Razão social:'  
    expect(page).not_to have_field 'Nome fantasia'
    expect(page).not_to have_field 'Razão social'
  end

  it 'trying to access my_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    # Act
    login_as(user)
    visit my_inn_path
    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Nome fantasia:'
    expect(page).not_to have_content 'Razão social:'  
    expect(page).not_to have_field 'Nome fantasia'
    expect(page).not_to have_field 'Razão social'
  end

  it 'trying to access edit_inn_path' do
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: false)
    # Act
    login_as(user)
    visit edit_inn_path
    # Assert
    expect(current_path).to eq root_path
    expect(page).not_to have_content 'Nome fantasia:'
    expect(page).not_to have_content 'Razão social:'  
    expect(page).not_to have_field 'Nome fantasia'
    expect(page).not_to have_field 'Razão social'
  end
end