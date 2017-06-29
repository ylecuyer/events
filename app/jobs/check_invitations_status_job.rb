class CheckInvitationsStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)

    event_id = args[0]

    event = Event.find(event_id)

    mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
    mg_events = Mailgun::Events.new(mg_client, ENV['MAILGUN_DOMAIN'])

    result = mg_events.get({"tags" => event.tag})

    loop do

      result.to_h['items'].reverse_each do |item|
        SaveLogJob.perform_later(item)
      end

      result = mg_events.next
      break unless result.to_h['items'].count > 0
    end

  end
end
