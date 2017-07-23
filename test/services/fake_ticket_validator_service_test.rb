require 'test_helper'

class FakeTicketValidatorServiceTest < ActiveSupport::TestCase

  test "test VALID" do
    fake_ticket_validator = FakeTicketValidatorService.new(ref: 'VALID')
    fake_ticket_validator.validate

    assert_equal true, fake_ticket_validator.is_valid?
    assert_equal "", fake_ticket_validator.message
    assert_equal Attendee.dummy.attributes, fake_ticket_validator.attendee.attributes
  end
 
  test "test ALRDY" do
    fake_ticket_validator = FakeTicketValidatorService.new(ref: 'ALRDY')
    fake_ticket_validator.validate

    assert_equal false, fake_ticket_validator.is_valid?
    assert_equal "Already checked in", fake_ticket_validator.message
    assert_equal Attendee.dummy.attributes, fake_ticket_validator.attendee.attributes
  end
 
  test "test BEFORE" do
    fake_ticket_validator = FakeTicketValidatorService.new(ref: 'BEFORE')
    fake_ticket_validator.validate

    assert_equal false, fake_ticket_validator.is_valid?
    assert_equal "Barcode shouldn't be scanned before the event", fake_ticket_validator.message
    assert_equal Attendee.dummy.attributes, fake_ticket_validator.attendee.attributes
  end
 
  test "test NOTINV" do
    fake_ticket_validator = FakeTicketValidatorService.new(ref: 'NOTINV')
    fake_ticket_validator.validate

    assert_equal false, fake_ticket_validator.is_valid?
    assert_equal "Not invited", fake_ticket_validator.message
    assert_equal Attendee.dummy.attributes, fake_ticket_validator.attendee.attributes
  end

  # test "the truth" do
  #   assert true
  # end
end
