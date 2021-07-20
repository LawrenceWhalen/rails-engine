FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Number.number(digits: 16)}
    credit_card_expiration_date { Faker::Date.forward(days: 600) }
    result { ['success', 'failed'].sample }
  end
end