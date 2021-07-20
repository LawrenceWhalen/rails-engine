FactoryBot.define do
  factory :merchant do
    name { Faker::Book.title }
  end
end
