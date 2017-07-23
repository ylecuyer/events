class StaticController < ApplicationController

  skip_before_action :authenticate_user!, only: [:example_validate]

  def index
    authorize :static, :show?
    @event = Event.new
    @events = Event.all
  end

  def configuration
    authorize :static, :show_configuration?

    if Rails.env.development?
	    @ngrok_https = NgrokService.new.public_url
	    @qrcode = RQRCode::QRCode.new(@ngrok_https)
    end
    @total = MailgunService.new.total_sent_mail_this_month
  end

  def example_validate

    authorize :static, :show?

    case params[:ref]
    when 'VALID'
      @is_valid = true
      @message = ""
      @attendee = Attendee.dummy
    when 'ALRDY'
      @is_valid = false
      @message = "Already checked in"
    when 'BEFORE'
      @is_valid = false
      @message = "Barcode shouldn't be scanned before the event"
    when 'NOTINV'
      @is_valid = false
      @message = "Not invited"
    end

    render 'events/validate', layout: false
  end
end
