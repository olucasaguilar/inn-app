FactoryBot.define do
  factory :user do
    name { 'Usuário' }
    email { 'user@gmail.com' }
    password { '123456' }
  end
end