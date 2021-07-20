FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.number(digits: 4)}
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end