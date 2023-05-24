# == Schema Information
#
# Table name: event_attendees
#
#  id                             :uuid             not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  attendee_departure_location_id :uuid             not null
#  attendee_id                    :uuid             not null
#  event_id                       :uuid             not null
#
# Indexes
#
#  index_event_attendees_on_attendee_departure_location_id  (attendee_departure_location_id)
#  index_event_attendees_on_attendee_id                     (attendee_id)
#  index_event_attendees_on_event_id                        (event_id)
#  index_event_attendees_on_event_id_and_attendee_id        (event_id,attendee_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (attendee_departure_location_id => locations.id)
#  fk_rails_...  (attendee_id => users.id)
#  fk_rails_...  (event_id => events.id)
#
class EventAttendeeSerializer
  include JSONAPI::Serializer

  attribute :user do |event_attendee|
    UserSerializer.new(event_attendee.attendee).serializable_hash
  end

  attribute :location do |event_attendee|
    LocationSerializer.new(event_attendee.attendee_departure_location).serializable_hash
  end
end
