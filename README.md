# README

# Documentação da API de Pousadas (Inns)

Abaixo, uma descrição dos endpoints disponíveis.

## 1. Listar Todas as Pousadas

### Endpoint
```
GET /api/v1/inns
```

### Descrição
Retorna a lista de todas as pousadas cadastradas.

### Parâmetros de Consulta Opcionais
- `search` (opcional): Filtra as pousadas com base no nome, cidade ou estado.

## 2. Listar Quartos de uma Pousada Específica

### Endpoint
```
GET /api/v1/inns/:id/rooms
```

### Descrição
Retorna a lista de quartos de uma pousada específica.

### Parâmetros
- `id` (obrigatório): ID da pousada.

### Exemplo de Uso
```ruby
GET /api/v1/inns/1/rooms
```

## 3. Verificar Disponibilidade de um Quarto em uma Pousada

### Endpoint
```
GET /api/v1/inns/:id/rooms/:room_id/availability
```

### Descrição
Verifica a disponibilidade de um quarto em uma pousada para um determinado período.

### Parâmetros
- `id` (obrigatório): ID da pousada.
- `room_id` (obrigatório): ID do quarto.
- `check_in` (obrigatório): Data de check-in no formato 'YYYY-MM-DD'.
- `check_out` (obrigatório): Data de check-out no formato 'YYYY-MM-DD'.
- `guests` (obrigatório): Número de hóspedes.

### Exemplo de Uso
```ruby
GET /api/v1/inns/1/rooms/2/availability?check_in='2023-12-01'&check_out='2023-12-05'&guests=2
```

## 4. Obter Detalhes de uma Pousada

### Endpoint
```
GET /api/v1/inns/:id
```

### Descrição
Retorna os detalhes de uma pousada específica, incluindo informações sobre avaliações e políticas.

### Parâmetros
- `id` (obrigatório): ID da pousada.

### Exemplo de Uso
```ruby
GET /api/v1/inns/1
```

## Observações Gerais
- Todos os endpoints retornam dados no formato JSON.
- Em caso de sucesso, a resposta terá o código 200. Em caso de erro, o código e uma mensagem explicativa serão retornados.