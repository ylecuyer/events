# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#
# Indexes
#
#  index_categories_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#

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
