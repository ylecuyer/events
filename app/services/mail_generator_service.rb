class MailGeneratorService

	def initialize(params)
		@event = params[:event]
		@attendee = params[:attendee]
		@to = params[:to]
	end 

	def generate_and_send_now
		mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']

		mb_obj = Mailgun::MessageBuilder.new()
		mb_obj.from("reception.bogota.amba@gmail.com", {"first"=>"RECEPTION", "last" => "Bogota-Amba"});
		mb_obj.add_recipient(:to, @to || @attendee.email);
		mb_obj.subject(@event.subject);

		merged_model = Mustache.render(@event.model, {first_name: @attendee.first_name, last_name: @attendee.last_name, full_name: @attendee.full_name})

		html_doc = Nokogiri::HTML(merged_model)

		imgs = html_doc.css('img')
		imgs.each do |img|
			src = img['src']
			mb_obj.add_inline_image "public#{src}"
			cid = src.split('/').last
			img['src'] = "cid:#{cid}"
		end

		mb_obj.body_html(html_doc.to_html);
		mb_obj.body_text(html_doc.text);
		mb_obj.add_tag(@event.tag)

    @qrcode = RQRCode::QRCode.new("https://attendize.ambafrance.co/events/#{@event.id}/validate?ref=#{@attendee.reference}")
		string = AttendeesController.render('ticket.pdf.erb', locals: { attendee: @attendee, event: @event, qrcode: @qrcode }, layout: false)
		pdf = WickedPdf.new.pdf_from_string(string, return_file: true)
		mb_obj.add_attachment(pdf, 'ticket.pdf')
		mg_client.send_message(ENV['MAILGUN_DOMAIN'], mb_obj)
	end
end
