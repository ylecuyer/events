class SaveLogJob < ApplicationJob
  queue_as :default

  def perform(*args)
    item = args[0]

    attendee = Attendee.find_by(mailgun_id: item['message']['headers']['message-id'])

    return unless attendee

    log = Log.find_or_create_by(internal_id: item['id'])

    log.internal_id = item['id']
    log.timestamp = item['timestamp']
    log.json = item
    log.attendee = attendee

    log.save
    attendee.save
  end
end
