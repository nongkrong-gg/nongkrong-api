# == Schema Information
#
# Table name: locations
#
#  id         :uuid             not null, primary key
#  address    :string
#  latitude   :decimal(10, 6)   not null
#  longitude  :decimal(10, 6)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_latitude_and_longitude  (latitude,longitude) UNIQUE
#
class Location < ApplicationRecord
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: lambda { |obj|
    obj.latitude.present? && obj.longitude.present? && (obj.latitude_changed? || obj.longitude_changed?)
  }

  validates :latitude, :longitude, presence: true
  validates :latitude, uniqueness: { scope: :longitude }
end
