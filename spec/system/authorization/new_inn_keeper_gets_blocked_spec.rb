require 'rails_helper'

describe 'New inn keeper gets blocked' do
  it 'trying to access my_inn_path' do
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

  it 'trying to access edit_inn_path' do
    # Arrange
    user = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
    login_as(user)
    # Act
    visit edit_inn_path
    # Assert
    expect(current_path).to eq new_inn_path
    expect(page).not_to have_content 'Nome fantasia:'
    expect(page).not_to have_content 'Razão social:'
    expect(page).to have_field 'Nome fantasia'
    expect(page).to have_field 'Razão social'
  end
end