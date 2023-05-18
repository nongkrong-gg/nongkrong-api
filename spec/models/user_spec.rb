require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :username }
    it { should validate_presence_of :reset_password_token }
    it { should_not allow_value('name with space').for(:username) }
  end
end
