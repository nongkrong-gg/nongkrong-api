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
FactoryBot.define do
  factory :location do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
