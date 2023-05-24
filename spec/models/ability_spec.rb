require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:user) { create(:user) }

  subject { described_class.new(user) }

  describe 'abilities' do
    describe 'Event' do
      let(:event) { create(:event) }
      let(:organized_event) { create(:event, organizer: user) }
      let!(:event_attendee) { create(:event_attendee, event:, attendee: user) }

      context 'when user is not logged in' do
        subject { described_class.new(nil) }

        it { is_expected.not_to be_able_to(:manage, organized_event) }
        it { is_expected.not_to be_able_to(:read, event) }
      end

      context 'when user is logged in' do
        it { is_expected.to be_able_to(:manage, organized_event) }
        it { is_expected.to be_able_to(:read, event) }
      end
    end
  end
end
