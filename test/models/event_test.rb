require 'test_helper'

class EventTest < ActiveSupport::TestCase
 
  test "Event tag for mailgun" do
    event = events(:first)
    assert_equal "Event-1", event.tag
  end

  test "dummy event" do
    dummy_event = Event.dummy

    assert_equal "Fête nationale", dummy_event.name
    assert_equal "Residence de France", dummy_event.venue
    assert_equal "2017-07-14 12:30".in_time_zone, dummy_event.start
  end
  
  # test "the truth" do
  #   assert true
  # end
end
