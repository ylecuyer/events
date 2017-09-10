class TicketValidatorService
  def initialize(params)
    @event = params[:event]
    @attendee = params[:attendee]

    @is_valid = false
    @message = 'Not invited'
  end

  def is_valid?
    @is_valid
  end

  attr_reader :message

  def validate
    return unless @attendee

    if Time.now >= (@event.start - 2.hours)
      if @attendee.checkin_at.present?
        @is_valid = false
        @message = 'Already checked in'
      else
        @is_valid = true
        @message = ''

        @attendee.checkin!
      end
    else
      @is_valid = false
      @message = "Barcode shouldn't be scanned before the event"
    end
  end
end
