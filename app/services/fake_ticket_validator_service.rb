class FakeTicketValidatorService
  def initialize(params)
    @ref = params[:ref]

    @is_valid = false
    @message = 'Not invited'
  end

  def is_valid?
    @is_valid
  end

  attr_reader :message

  def attendee
    @attendee ||= Attendee.dummy
  end

  def validate
    case @ref
    when 'VALID'
      @is_valid = true
      @message = ''
    when 'ALRDY'
      @is_valid = false
      @message = 'Already checked in'
    when 'BEFORE'
      @is_valid = false
      @message = "Barcode shouldn't be scanned before the event"
    when 'NOTINV'
      @is_valid = false
      @message = 'Not invited'
    end
  end
end
