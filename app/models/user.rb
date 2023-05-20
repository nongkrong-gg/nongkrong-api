class User < ApplicationRecord
  has_many :events, foreign_key: 'organizer_id', inverse_of: :organizer, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :encrypted_password, presence: true
  validates :email, :username, uniqueness: true
  validates :email, format: Devise.email_regexp
  validates :username, format: { without: /\s/ }
end
