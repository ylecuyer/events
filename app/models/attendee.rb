# == Schema Information
#
# Table name: attendees
#
#  id          :integer          not null, primary key
#  first_name  :string
#  last_name   :string
#  email       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :integer
#  category_id :integer
#  reference   :string
#  mailgun_id  :string
#  extra_data  :jsonb
#  checkin_at  :datetime
#
# Indexes
#
#  index_attendees_on_category_id  (category_id)
#  index_attendees_on_event_id     (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (event_id => events.id)
#

class Attendee < ApplicationRecord
  before_create :save_reference

  belongs_to :category
  belongs_to :event

  has_many :logs, -> { order 'timestamp asc' }

  validates :first_name, :last_name, :email, presence: true

  scope :with_logs, -> { joins(:logs) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def invitation_status
    if log
      str = log['event'] + " (#{Time.at(log['timestamp'].to_f)})"
      if log['delivery-status']
        str += " [#{log['delivery-status']['code']} / #{log['delivery-status']['message']} / #{log['delivery-status']['description']}"
        str +=	" / retry in #{log['delivery-status']['retry-seconds']} seconds" if log['delivery-status']['retry-seconds']
        str += ' ]'
      end
    else
      'queued'
    end
  end

  def status_icon_name
    return 'icons/new.png' if mailgun_id.blank?
    return 'icons/hourglass.png' if mailgun_id.present? && log.blank?

    return 'icons/accept.png' if log['event'] == 'delivered'
    return 'icons/exclamation.png' if log['severity'].present? && log['severity'] == 'permanent'
    return 'icons/time.png' if log['event'] == 'accepted'
    return 'icons/error.png' if log['severity'] == 'temporary'
    'icons/question.gif'
  end

  def checkin!
    self.checkin_at = Time.now
    save
  end

  def self.dummy
    attendee = Attendee.new

    attendee.last_name = 'DummyLastName'
    attendee.first_name = 'DummyFirstName'
    attendee.reference = 'DUMMYX'

    attendee.category = Category.dummy
    attendee.event = Event.dummy

    attendee
  end

  private

  def save_reference
    loop do
      reference = generate_reference
      unless Attendee.where(reference: reference).first
        self.reference = reference
        break
      end
    end
  end

  def generate_reference(size = 6)
    charset = %w{2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end
end
