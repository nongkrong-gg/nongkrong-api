# == Schema Information
#
# Table name: events
#
#  id                :uuid             not null, primary key
#  date              :datetime         not null
#  description       :text
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  final_location_id :uuid
#  organizer_id      :uuid             not null
#
# Indexes
#
#  index_events_on_final_location_id  (final_location_id)
#  index_events_on_organizer_id       (organizer_id)
#
# Foreign Keys
#
#  fk_rails_...  (final_location_id => locations.id)
#  fk_rails_...  (organizer_id => users.id)
#
class Event < ApplicationRecord
  has_many :event_attendees, dependent: :destroy, inverse_of: :event
  has_many :attendees, through: :event_attendees
  belongs_to :final_location, class_name: 'Location', optional: true
  belongs_to :organizer, class_name: 'User'

  validates :title, :date, presence: true
end
