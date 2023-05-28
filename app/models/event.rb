# == Schema Information
#
# Table name: events
#
#  id                   :uuid             not null, primary key
#  date                 :datetime         not null
#  description          :text
#  title                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  final_location_id    :uuid
#  midpoint_location_id :uuid
#  organizer_id         :uuid             not null
#
# Indexes
#
#  index_events_on_final_location_id     (final_location_id)
#  index_events_on_midpoint_location_id  (midpoint_location_id)
#  index_events_on_organizer_id          (organizer_id)
#
# Foreign Keys
#
#  fk_rails_...  (final_location_id => locations.id)
#  fk_rails_...  (midpoint_location_id => locations.id)
#  fk_rails_...  (organizer_id => users.id)
#
class Event < ApplicationRecord
  has_many :attendees, class_name: 'EventAttendee', dependent: :destroy, inverse_of: :event
  has_many :attendee_departure_locations, through: :attendees

  belongs_to :midpoint_location, class_name: 'Location', optional: true
  accepts_nested_attributes_for :midpoint_location
  belongs_to :final_location, class_name: 'Location', optional: true
  belongs_to :organizer, class_name: 'User'

  validates :title, :date, presence: true

  def check_in!(attendee:, latitude:, longitude:)
    attendee_departure_location = Location.find_or_initialize_by(latitude:, longitude:)
    attendees.create!(attendee:, attendee_departure_location:)
  end

  def calculate_midpoint_location!
    return if attendee_departure_locations.empty? || attendee_departure_locations.one?

    midpoint_location = Geocoder::Calculations.geographic_center(attendee_departure_locations)
    update!(midpoint_location: Location.find_or_initialize_by(latitude: midpoint_location[0],
                                                              longitude: midpoint_location[1]))
  end
end
