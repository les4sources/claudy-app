FactoryBot.define do
  factory :lodging do
    association :location
    name { "MyString" }
    description { "MyText" }
    summary { "MyString" }
    price_night_cents { 1 }
    price_weekend_cents { 1 }
    party_hall_availability { false }
  end
end
