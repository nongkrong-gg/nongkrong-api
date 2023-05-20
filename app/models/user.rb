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
class User < ApplicationRecord
  has_many :event_attendees, foreign_key: 'attendee_id', dependent: :destroy, inverse_of: :attendee
  has_many :events, through: :event_attendees
  has_many :self_organized_events, foreign_key: 'organizer_id', class_name: 'Event', dependent: :destroy,
                                   inverse_of: :organizer

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :username, :encrypted_password, presence: true
  validates :email, :username, uniqueness: true
  validates :email, format: Devise.email_regexp
  validates :username, format: { without: /\s/ }
end
