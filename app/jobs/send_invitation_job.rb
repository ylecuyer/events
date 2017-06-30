class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(*args)

    event_id = args[0]
    attendee_id = args[1]

    event = Event.find event_id
    attendee = Attendee.find attendee_id

    result = MailGeneratorService.new(event: event, attendee: attendee).generate_and_send_now

    attendee.mailgun_id = result.to_h['id'][1..-2] #Remove < and > in <MAILGUN-ID>
    attendee.save
  end
end
