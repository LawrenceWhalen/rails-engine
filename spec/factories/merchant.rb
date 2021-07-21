FactoryBot.define do
  factory :merchant do
    name { Faker::Book.unique.title }
  end
end
