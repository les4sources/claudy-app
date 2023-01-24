class Booking < ApplicationRecord
  # 🚅 add concerns above.

  attr_accessor :booking_type # lodging || rooms
  # 🚅 add attribute accessors above.

  belongs_to :location
  belongs_to :person
  belongs_to :lodging, optional: true
  # 🚅 add belongs_to associations above.

  has_many :reservations
  has_many :rooms, through: :reservations
  # 🚅 add has_many associations above.

  has_one :team, through: :location
  has_rich_text :notes
  # 🚅 add has_one associations above.

  default_scope -> { order(from_date: :desc) }
  # 🚅 add scopes above.

  validates :person, scope: true
  validates :lodging, scope: true
  validates_presence_of :from_date
  validates_presence_of :to_date
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_people
    # please specify what objects should be considered valid for assigning to `person`.
    # the resulting code should probably look something like `team.people`.
    team.people
  end

  def valid_lodgings
    # please specify what objects should be considered valid for assigning to `lodging`.
    # the resulting code should probably look something like `team.lodgings`.
    location.lodgings
  end

  # 🚅 add methods above.
end
