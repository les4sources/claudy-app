FactoryBot.define do
  factory :location do
    name { "MyString" }
    address { "MyString" }
    association :team
  end
end
