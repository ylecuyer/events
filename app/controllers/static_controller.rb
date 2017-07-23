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

    fake_ticket_validator = FakeTicketValidatorService.new(ref: params[:ref])
    fake_ticket_validator.validate

    @attendee = fake_ticket_validator.attendee
    @is_valid = fake_ticket_validator.is_valid?
    @message = fake_ticket_validator.message
      
    render 'events/validate', layout: false
  end
end
