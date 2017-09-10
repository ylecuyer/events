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

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'dummy category' do
    dummy_category = Category.dummy

    assert_equal 'DUMMY', dummy_category.name
  end

  # test "the truth" do
  #   assert true
  # end
end
