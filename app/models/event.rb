class Event < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :organizer, class_name: 'User'

  validates :title, :date, presence: true
end
