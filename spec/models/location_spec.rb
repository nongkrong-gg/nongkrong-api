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
require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { build(:location) }

  describe 'validations' do
    it { should be_valid }

    it {
      should have_many(:finalized_events)
        .dependent(:nullify)
        .class_name('Event')
        .with_foreign_key('final_location_id')
        .inverse_of(:final_location)
    }
    it {
      should have_many(:event_attendees)
        .dependent(:nullify)
        .with_foreign_key('attendee_departure_location_id')
        .inverse_of(:attendee_departure_location)
    }
    it { should have_many(:attender_events).through(:event_attendees) }

    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_uniqueness_of(:latitude).scoped_to(:longitude) }
  end

  describe 'reverse geocoding' do
    it 'should reverse geocode when latitude and longitude are present' do
      subject.save

      expect(subject.address).to be_present
    end

    it 'should not reverse geocode when latitude is not present' do
      subject.latitude = nil
      subject.save

      expect(subject.address).to be_nil
    end

    it 'should not reverse geocode when longitude is not present' do
      subject.longitude = nil
      subject.save

      expect(subject.address).to be_nil
    end

    it 'should not reverse geocode when latitude and longitude are not present' do
      subject.latitude = nil
      subject.longitude = nil
      subject.save

      expect(subject.address).to be_nil
    end

    it 'should not reverse geocode when latitude and longitude have not changed' do
      subject.save
      subject.address = nil
      subject.save

      expect(subject.address).to be_nil
    end

    it 'should reverse geocode when latitude has changed' do
      subject.save
      subject.address = nil
      subject.latitude = Faker::Address.latitude
      subject.save

      expect(subject.address).to be_present
    end

    it 'should reverse geocode when longitude has changed' do
      subject.save
      subject.address = nil
      subject.longitude = Faker::Address.longitude
      subject.save

      expect(subject.address).to be_present
    end

    it 'should reverse geocode when latitude and longitude have changed' do
      subject.save
      subject.address = nil
      subject.latitude = Faker::Address.latitude
      subject.longitude = Faker::Address.longitude
      subject.save

      expect(subject.address).to be_present
    end
  end
end
