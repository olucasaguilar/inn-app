user_01 = User.create!(name: 'Lucas', email: 'lucas@gmail.com', password: '123456', innkeeper: true)
user_02 = User.create!(name: 'Gabriel', email: 'gabriel@gmail.com', password: '123456', innkeeper: false)
user_03 = User.create!(name: 'Oliveira', email: 'oliveira@gmail.com', password: '123456', innkeeper: true)
user_04 = User.create!(name: 'Aguilar', email: 'aguilar@gmail.com', password: '123456', innkeeper: false)
user_05 = User.create!(name: 'Valdeir', email: 'valdeir@gmail.com', password: '123456', innkeeper: true)
user_06 = User.create!(name: 'Ribeiro', email: 'ribeiro@gmail.com', password: '123456', innkeeper: true)


address_01 = Address.new(street: 'Rua dos Bobos, 115', neighborhood: 'Vila Madalena', state: 'SP', 
                         city: 'São Paulo', zip_code: '05412000')
inn_01 = Inn.create!(name: 'Pousada do Russo', social_name: 'Pousada do Alemão LTDA', 
                     cnpj: '12345678901234', phone: '11999999999', email: 'pdalemao@gmail.com', 
                     address: address_01, user: user_01, status: :active)
room_01 = Room.create!(name: 'Quarto 1', description: 'Quarto com vista para o mar', dimension: 20,
                       max_occupancy: 2, value: 200, inn: user_01.inn, status: :active)
pm_01 = PaymentMethod.create!(name: 'Cartão de crédito', inn_additional: user_01.inn.inn_additional)
PricePeriod.create!(start_date: "2024-01-01", end_date: "2024-01-10", value: 100, room: room_01)
PricePeriod.create!(start_date: "2024-01-20", end_date: "2024-01-30", value: 200, room: room_01)


address_03 = Address.new(street: 'Avenida das Palmeiras, 500', neighborhood: 'Copacabana', state: 'RJ',
                         city: 'Rio de Janeiro', zip_code: '22011000')
inn_03 = Inn.create!(name: 'Hotel Bella Vista', social_name: 'Bella Vista Hospedagem LTDA',
                     cnpj: '98765432109876', phone: '2122222222', email: 'bellavista@gmail.com',
                     address: address_03, user: user_03, status: :active)
room_03 = Room.create!(name: 'Suite Master', description: 'Suite com vista para o mar e varanda', dimension: 30,
                       max_occupancy: 3, value: 300, inn: user_03.inn)
pm_03 = PaymentMethod.create!(name: 'Boleto Bancário', inn_additional: user_03.inn.inn_additional)
PricePeriod.create!(start_date: "2024-02-10", end_date: "2024-02-20", value: 250, room: room_03)
PricePeriod.create!(start_date: "2024-03-05", end_date: "2024-03-15", value: 350, room: room_03)


address_05 = Address.new(street: 'Rua das Flores, 123', neighborhood: 'Ipanema', state: 'RJ',
                         city: 'Rio de Janeiro', zip_code: '22410000')
inn_05 = Inn.create!(name: 'Maravilhas do Mar', social_name: 'Maravilhas do Mar Hotelaria LTDA',
                     cnpj: '11112222333344', phone: '2133333333', email: 'maravilhasmar@gmail.com',
                     address: address_05, user: user_05, status: :active)
room_05 = Room.create!(name: 'Quarto Luxo', description: 'Quarto luxuoso com jacuzzi', dimension: 25,
                       max_occupancy: 2, value: 400, inn: user_05.inn, status: :active)
pm_05 = PaymentMethod.create!(name: 'Transferência Bancária', inn_additional: user_05.inn.inn_additional)
PricePeriod.create!(start_date: "2024-04-01", end_date: "2024-04-10", value: 380, room: room_05)
PricePeriod.create!(start_date: "2024-05-20", end_date: "2024-05-30", value: 450, room: room_05)


address_06 = Address.new(street: 'Avenida das Águias, 700', neighborhood: 'Praia do Sol', state: 'BA',
                         city: 'Salvador', zip_code: '40000000')
inn_06 = Inn.create!(name: 'Sol & Mar Resort', social_name: 'Sol & Mar Empreendimentos Hoteleiros LTDA',
                     cnpj: '09876543210987', phone: '7133333333', email: 'solmarresort@gmail.com',
                     address: address_06, user: user_06)
room_06 = Room.create!(name: 'Suíte Praiana', description: 'Suíte com vista para o mar e varanda privativa', dimension: 35,
                       max_occupancy: 4, value: 500, inn: user_06.inn)
pm_06 = PaymentMethod.create!(name: 'Dinheiro', inn_additional: user_06.inn.inn_additional)
PricePeriod.create!(start_date: "2024-06-15", end_date: "2024-06-25", value: 450, room: room_06)
PricePeriod.create!(start_date: "2024-07-10", end_date: "2024-07-20", value: 600, room: room_06)
