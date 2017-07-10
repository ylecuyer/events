class UpdateStatusJob < ApplicationJob
  queue_as :default

  def perform(*args)

    mailgun_id = args[0]

    mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
    mg_events = Mailgun::Events.new(mg_client, ENV['MAILGUN_DOMAIN'])

    result = mg_events.get({"message-id" => mailgun_id})

    loop do

      result.to_h['items'].each do |item|
        SaveLogJob.perform_later(item)
      end

      result = mg_events.next
      break unless result.to_h['items'].count > 0
    end

  end
end
