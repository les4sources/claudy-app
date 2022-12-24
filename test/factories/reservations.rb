FactoryBot.define do
  factory :reservation do
    booking { nil }
    room { nil }
    date { "2022-12-24" }
    status { "MyString" }
  end
end
