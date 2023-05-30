require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:user) { create(:user) }

  subject { described_class.new(user) }

  describe 'abilities' do
    describe 'admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_able_to(:manage, :all) }
    end
    describe 'user' do
      describe 'Event' do
        let(:event) { create(:event) }
        let(:organized_event) { create(:event, organizer: user) }

        context 'when user is not logged in' do
          subject { described_class.new(nil) }

          it { is_expected.not_to be_able_to(:manage, organized_event) }
          it { is_expected.not_to be_able_to(:read, event) }
          it { is_expected.not_to be_able_to(:check_in, event) }
        end

        context 'when user is logged in' do
          it { is_expected.to be_able_to(:manage, organized_event) }
          it { is_expected.to be_able_to(:read, event) }
          it { is_expected.to be_able_to(:check_in, event) }
        end
      end
    end
  end
end
