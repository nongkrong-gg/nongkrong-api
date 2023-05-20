# == Schema Information
#
# Table name: events
#
#  id           :uuid             not null, primary key
#  date         :datetime         not null
#  description  :text
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :uuid
#  organizer_id :uuid             not null
#
# Indexes
#
#  index_events_on_location_id   (location_id)
#  index_events_on_organizer_id  (organizer_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (organizer_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :organizer, class_name: 'User'

  validates :title, :date, presence: true
end
