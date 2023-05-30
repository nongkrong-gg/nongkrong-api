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
    it { should have_many(:attendee_departure_locations).through(:attendees) }
    it { should belong_to :organizer }
    it { should belong_to(:midpoint_location).optional }

    it { should validate_presence_of :title }
    it { should validate_presence_of :date }
  end

  describe '#check_in!' do
    subject { create(:event) }
    let(:attendee) { create(:user) }
    let(:latitude) { Faker::Address.latitude }
    let(:longitude) { Faker::Address.longitude }

    context 'when attendee has not checked in' do
      it 'creates an attendee' do
        expect do
          subject.check_in!(attendee:, latitude:, longitude:)
        end.to change { EventAttendee.count }.by(1)
      end
    end

    context 'when attendee has already checked in' do
      before do
        subject.check_in!(attendee:, latitude:, longitude:)
      end

      it 'does not create an attendee' do
        expect do
          subject.check_in!(attendee:, latitude:, longitude:)
        end.to raise_error(ActiveRecord::RecordInvalid)
          .and change { EventAttendee.count }.by(0)
      end
    end

    context 'when another attendee has checked in with same coordinates' do
      let(:other_attendee) { create(:user) }

      before do
        subject.check_in!(attendee:, latitude:, longitude:)
      end

      it 'creates an attendee but not a location' do
        expect do
          subject.check_in!(attendee: other_attendee, latitude:, longitude:)
        end.to change { EventAttendee.count }.by(1)
                                             .and change { Location.count }.by(0)
      end
    end
  end

  describe '#calculate_midpoint_location!' do
    subject { create(:event) }

    context 'when there are no attendees' do
      it 'does not create a midpoint location' do
        expect do
          subject.calculate_midpoint_location!
        end.to change { Location.count }.by(0)
        expect(subject.midpoint_location).to be_nil
      end
    end

    context 'when there is one attendee' do
      let(:attendee) { create(:user) }
      let(:latitude) { Faker::Address.latitude }
      let(:longitude) { Faker::Address.longitude }

      before do
        subject.check_in!(attendee:, latitude:, longitude:)
      end

      it 'does not create a midpoint location' do
        expect do
          subject.calculate_midpoint_location!
        end.to change { Location.count }.by(0)
        expect(subject.midpoint_location).to be_nil
      end
    end

    context 'when there are two or more attendees' do
      let(:attendee1) { create(:user) }
      let(:attendee2) { create(:user) }
      let(:latitude1) { Faker::Address.latitude }
      let(:longitude1) { Faker::Address.longitude }
      let(:latitude2) { Faker::Address.latitude }
      let(:longitude2) { Faker::Address.longitude }

      before do
        subject.check_in!(attendee: attendee1, latitude: latitude1, longitude: longitude1)
      end

      it 'creates a midpoint location' do
        expect do
          subject.check_in!(attendee: attendee2, latitude: latitude2, longitude: longitude2)
        end.to change { Location.count }.by(2)
                                        .and change { subject.midpoint_location }.from(nil).to be_present
      end
    end
  end
end
