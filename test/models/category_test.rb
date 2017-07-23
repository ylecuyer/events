require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test "dummy category" do
    dummy_category = Category.dummy

    assert_equal "DUMMY", dummy_category.name
  end
  
  # test "the truth" do
  #   assert true
  # end
end
