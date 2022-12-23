class Booking < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :location
  belongs_to :person
  belongs_to :lodging, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :location
  has_rich_text :notes
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :person, scope: true
  validates :lodging, scope: true
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
