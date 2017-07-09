require 'test_helper'

class EventTest < ActiveSupport::TestCase
 
  test "Event tag for mailgun" do
    event = events(:first)
    assert_equal "Event-1", event.tag
  end
  
  # test "the truth" do
  #   assert true
  # end
end
