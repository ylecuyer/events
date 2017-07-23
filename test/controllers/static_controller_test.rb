require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest

  test "should show the index page" do
    login_as(users(:user), :scope => :user)
    get '/'
    assert_response :success
  end

  test "should not show config to non admin" do
    login_as(users(:user), :scope => :user)
    assert_raise Pundit::NotAuthorizedError do
      get '/configuration'
    end
  end

  test "should show config to admin" do
    login_as(users(:admin), :scope => :user)
    MailgunService.any_instance.stubs(:total_sent_mail_this_month).returns(214)
    get '/configuration'
    assert_response :success
  end

  test "should validate fake tickets" do
    get example_validate_path(ref: 'VALID')
    assert_response :success
  end

end
