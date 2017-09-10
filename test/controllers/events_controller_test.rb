require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test 'should show all events' do
    login_as(users(:user), scope: :user)
    get events_path
    assert_response :success
  end

  test 'should show event details' do
    login_as(users(:user), scope: :user)
    get event_path(events(:first))
    assert_response :success
  end

  test 'should show validate qrcode without being logged in' do
    event = events(:first)
    get validate_event_path(event, ref: 'DUMMY')
    assert_response :success
  end
end
