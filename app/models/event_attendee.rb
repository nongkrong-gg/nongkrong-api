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
class EventAttendee < ApplicationRecord
  belongs_to :event
  belongs_to :attendee, class_name: 'User'
  belongs_to :attendee_departure_location, class_name: 'Location'
  accepts_nested_attributes_for :attendee_departure_location

  validates :attendee_id, uniqueness: { scope: :event_id }

  after_save :calculate_event_midpoint_location!, if: :saved_change_to_attendee_departure_location_id?

  private

  def calculate_event_midpoint_location!
    event.calculate_midpoint_location!
  end
end
