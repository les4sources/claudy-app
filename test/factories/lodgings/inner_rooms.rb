FactoryBot.define do
  factory :lodgings_inner_room, class: 'Lodgings::InnerRoom' do
    lodging { nil }
    room { nil }
  end
end
