FactoryBot.define do
  factory :booking do
    team { nil }
    person { nil }
    lodging { nil }
    from_date { "2022-12-21" }
    to_date { "2022-12-21" }
    status { "MyString" }
    adults { 1 }
    children { 1 }
    payment_status { "MyString" }
    payment_method { "MyString" }
    bedsheets { false }
    towels { false }
    notes { "MyText" }
    shown_price_cents { 1 }
    price_cents { 1 }
    invoice_status { "MyString" }
    contract_status { "MyString" }
    checkin_time { "MyString" }
    options { "MyString" }
    comments { "MyText" }
    selected_tier { "MyString" }
    token { "MyString" }
  end
end
