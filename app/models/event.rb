# == Schema Information
#
# Table name: events
#
#  id                   :uuid             not null, primary key
#  date                 :datetime         not null
#  description          :text
#  final_location       :string
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  midpoint_location_id :uuid
#  organizer_id         :uuid             not null
#
# Indexes
#
#  index_events_on_midpoint_location_id  (midpoint_location_id)
#  index_events_on_organizer_id          (organizer_id)
#
# Foreign Keys
#
#  fk_rails_...  (midpoint_location_id => locations.id)
#  fk_rails_...  (organizer_id => users.id)
#
class Event < ApplicationRecord
  has_many :attendees, class_name: 'EventAttendee', dependent: :destroy, inverse_of: :event
  has_many :attendee_departure_locations, through: :attendees

  belongs_to :midpoint_location, class_name: 'Location', optional: true
  accepts_nested_attributes_for :midpoint_location
  belongs_to :organizer, class_name: 'User'

  validates :title, :date, presence: true

  def check_in!(attendee:, latitude:, longitude:)
    attendee_departure_location = get_location(latitude:, longitude:)
    attendees.create!(attendee:, attendee_departure_location:)
  end

  def calculate_midpoint_location!
    return if attendee_departure_locations.empty? || attendee_departure_locations.one?

    latitude, longitude = Geocoder::Calculations.geographic_center(attendee_departure_locations)
    update!(midpoint_location: get_location(latitude:, longitude:))
  end

  private

  def get_location(latitude:, longitude:)
    Rails.cache.fetch("location-#{latitude}-#{longitude}", expires_in: 2.days) do
      Location.find_or_initialize_by(latitude:, longitude:)
    end
  end
end
