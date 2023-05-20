require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { should be_valid }
    it { should have_many(:events).with_foreign_key('organizer_id').dependent(:destroy).inverse_of(:organizer) }
    it { should validate_presence_of :email }
    it { should validate_presence_of :username }
    it { should validate_presence_of :encrypted_password }

    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of :username }

    it { should allow_value('test@test.test').for(:email) }
    it { should_not allow_value('testtest.test').for(:email) }

    it { should_not allow_value('name with space').for(:username) }
    it { should allow_value('name_without_space').for(:username) }
  end
end
