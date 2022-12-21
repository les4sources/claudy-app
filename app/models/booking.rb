class Booking < ApplicationRecord
  belongs_to :team
  belongs_to :person
  belongs_to :lodging
end
