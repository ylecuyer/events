require 'test_helper'

class TicketValidatorServiceTest < ActiveSupport::TestCase
  setup do
    @event = events(:first)
    @attendee = attendees(:ylecuyer)
    @ticket_validator = TicketValidatorService.new(event: @event, attendee: @attendee)
  end

  test 'Tickets scaned before event must be invalid' do
    Timecop.freeze(@event.start - 3.hours) do
      @ticket_validator.validate
      assert_equal false, @ticket_validator.is_valid?
      assert_equal "Barcode shouldn't be scanned before the event", @ticket_validator.message
    end
  end

  test 'Ticket scaned for the first time during the event is valid' do
    Timecop.freeze(@event.start) do
      @ticket_validator.validate
      assert_equal true, @ticket_validator.is_valid?
      assert_equal '', @ticket_validator.message
    end
  end

  test 'Ticket scaned twice during the event is invalid' do
    Timecop.freeze(@event.start) do
      @ticket_validator.validate
      @ticket_validator.validate
      assert_equal false, @ticket_validator.is_valid?
      assert_equal 'Already checked in', @ticket_validator.message
    end
  end

  test 'Ticket not belong to event is invalid' do
    attendee = @event.attendees.where(reference: 'DUMMY').first
    dummy_ticket_validator = TicketValidatorService.new(event: @event, attendee: attendee).validate
    assert_equal false, @ticket_validator.is_valid?
    assert_equal 'Not invited', @ticket_validator.message
  end

  # test "the truth" do
  #   assert true
  # end
end
