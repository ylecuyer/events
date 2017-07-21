class ApplicationHelperTest < ActionView::TestCase

  test "Alert helper" do
		assert_equal("alert alert-info", flash_class("notice"))
		assert_equal("alert alert-success", flash_class("success"))
		assert_equal("alert alert-danger", flash_class("error"))
		assert_equal("alert alert-warning", flash_class("alert"))
  end

end
