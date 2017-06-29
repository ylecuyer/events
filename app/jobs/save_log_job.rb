class SaveLogJob < ApplicationJob
  queue_as :default

  def perform(*args)
    item = args[0]

    attendee = Attendee.find_by_mailgun_id(item['message']['headers']['message-id'])

    return unless attendee

    log = Log.find_or_create_by(internal_id: item['id'])

    log.internal_id = item['id']
    log.timestamp = item['timestamp']
    log.json = item
    log.attendee = attendee

    log.save

    str = item['event'] + " (#{Time.at(item['timestamp'].to_f)})"
    if item['delivery-status']
      str +=  " [#{item['delivery-status']['code']} / #{item['delivery-status']['message']}"
      str +=	" / retry in #{item['delivery-status']['retry-seconds']} seconds" if item['delivery-status']['retry-seconds']
      str +=  " ]"
    end
    attendee.invitation_status = str
    attendee.is_processing_status_update = false
    attendee.save
  end
end
