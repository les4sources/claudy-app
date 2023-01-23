class Lodging < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :location
  # 🚅 add belongs_to associations above.

  # has_many :lodging_rooms
  # has_many :rooms, through: :lodging_rooms
  has_many :inner_rooms, class_name: "Lodgings::InnerRoom", dependent: :destroy
  has_many :rooms, through: :inner_rooms
  # 🚅 add has_many associations above.

  has_one :team, through: :location
  has_rich_text :description
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_rooms
    location.rooms
    # please specify what objects should be considered valid for assigning to `room_ids`.
    # the resulting code should probably look something like `team.rooms`.
  end

  # 🚅 add methods above.
  def available_on?(date)
    # none of the lodging rooms has a confirmed reservation
    true
    # Reservation
    #   .includes(:booking)
    #   .where(
    #     date: date,
    #     room: rooms.pluck(:id),
    #     booking: { status: "confirmed" }
    #   ).none?
  end

  def form_label
    "#{name} (#{summary})"
  end
end
