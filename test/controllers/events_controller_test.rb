require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  test "should show validate qrcode without being logged in" do
    event = events(:first)
    get validate_event_path(event, ref: "DUMMY")
    assert_response :success
  end

end
