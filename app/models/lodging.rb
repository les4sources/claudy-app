class Lodging < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :location
  # 🚅 add belongs_to associations above.

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
