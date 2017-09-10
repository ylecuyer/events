require 'test_helper'

class MailgunServiceTest < ActiveSupport::TestCase
  test 'total_sent_mail_this_month' do
    VCR.use_cassette("mailgun") do
      assert_equal 8, MailgunService.new.total_sent_mail_this_month
    end
  end

  # test "the truth" do
  #   assert true
  # end
end
