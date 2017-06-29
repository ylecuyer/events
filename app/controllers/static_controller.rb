class StaticController < ApplicationController
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
end
