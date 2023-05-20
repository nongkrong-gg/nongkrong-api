class Location < ApplicationRecord
  has_one :event, dependent: :nullify, inverse_of: :location

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: lambda { |obj|
    obj.latitude.present? && obj.longitude.present? && (obj.latitude_changed? || obj.longitude_changed?)
  }

  validates :latitude, :longitude, presence: true
  validates :latitude, uniqueness: { scope: :longitude }
end
