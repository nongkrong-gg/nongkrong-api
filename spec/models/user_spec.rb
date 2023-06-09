# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { should be_valid }

    it { should validate_presence_of :email }
    it { should validate_presence_of :username }
    it { should validate_presence_of :encrypted_password }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of :username }

    it { should allow_value('test@test.test').for(:email) }
    it { should_not allow_value('testtest.test').for(:email) }

    it { should_not allow_value('name with space').for(:username) }
    it { should allow_value('name_without_space').for(:username) }

    it { should define_enum_for(:role).with_values(%i[user admin]) }
  end

  describe '#jwt_payload' do
    it 'returns additional payload' do
      expect(subject.jwt_payload).to eq({ email: subject.email, username: subject.username })
    end
  end
end
