FactoryBot.define do
  factory :item do
    name { Faker::Hacker.unique.adjective }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end