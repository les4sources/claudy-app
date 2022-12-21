FactoryBot.define do
  factory :person do
    association :team
    firstname { "MyString" }
    lastname { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    notes { "MyText" }
  end
end
