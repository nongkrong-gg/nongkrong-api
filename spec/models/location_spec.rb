require 'rails_helper'

RSpec.describe Location, type: :model do
  subject { build(:location) }

  describe 'validations' do
    it { should be_valid }
    it { should have_one(:event).dependent(:nullify).inverse_of(:location) }
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
