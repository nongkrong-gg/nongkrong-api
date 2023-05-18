class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :reset_password_token, presence: true, uniqueness: true
  validates :username, format: { without: /\s/ }
end
