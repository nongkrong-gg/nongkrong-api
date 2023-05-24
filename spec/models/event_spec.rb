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
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build(:event) }

  describe 'validations' do
    it { should be_valid }

    it {
      should have_many(:attendees)
        .class_name('EventAttendee')
        .dependent(:destroy)
        .inverse_of(:event)
    }
    it { should belong_to :organizer }
    it { should belong_to(:final_location).optional }

    it { should validate_presence_of :title }
    it { should validate_presence_of :date }
  end
end
