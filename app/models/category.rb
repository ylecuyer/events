class Category < ApplicationRecord
  has_many :attendees
  belongs_to :event

  validates :name, presence: true
  validates :name, uniqueness: { scope: :event_id }
end
