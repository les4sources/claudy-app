class Reservation < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :location
  belongs_to :booking
  belongs_to :room
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :location
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :booking, scope: true
  validates :room, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_bookings
    # please specify what objects should be considered valid for assigning to `booking`.
    # the resulting code should probably look something like `team.bookings`.
    location.bookings
  end

  def valid_rooms
    # please specify what objects should be considered valid for assigning to `room`.
    # the resulting code should probably look something like `team.rooms`.
    location.rooms
  end

  # 🚅 add methods above.
end
