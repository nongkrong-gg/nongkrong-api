require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build(:event) }

  describe 'validations' do
    it { should be_valid }
    it { should belong_to :organizer }

    it { should validate_presence_of :title }
    it { should validate_presence_of :date }
  end
end
