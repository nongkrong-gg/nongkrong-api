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
class EventSerializer
  include JSONAPI::Serializer

  belongs_to :organizer, serializer: UserSerializer
  belongs_to :midpoint_location, serializer: LocationSerializer
  has_many :attendees, serializer: EventAttendeeSerializer

  attributes :title, :description, :date, :final_location
end
