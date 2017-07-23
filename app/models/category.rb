class Category < ApplicationRecord
  has_many :attendees
  belongs_to :event

  validates :name, presence: true
  validates :name, uniqueness: { scope: :event_id }

  def self.dummy
    category = Category.new
    category.name = "DUMMY"
    category
  end
end
