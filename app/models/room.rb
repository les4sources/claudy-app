class Room < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :location
  # 🚅 add belongs_to associations above.

  has_many :lodgings_inner_rooms, class_name: "Lodgings::InnerRoom", dependent: :destroy
  has_many :lodgings, through: :lodgings_inner_rooms
  has_many :reservations
  # 🚅 add has_many associations above.

  has_one :team, through: :location
  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.
end
