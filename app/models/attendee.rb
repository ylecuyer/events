class Attendee < ApplicationRecord

  before_create :save_reference	

  belongs_to :category
  belongs_to :event

  has_many :logs, -> { order 'timestamp asc' }

  validates :first_name, :last_name, :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def status_icon_name

    return 'icons/new.png' if mailgun_id.blank?
    return 'icons/hourglass.png' if mailgun_id.present? && logs.empty?

    last_log = logs.last
    data = last_log.json

    return 'icons/accept.png' if data['event'] == 'delivered'
    return 'icons/exclamation.png' if data['severity'].present? && data['severity'] == 'permanent'
    return 'icons/time.png' if data['event'] == 'accepted'
    return 'icons/error.png' if data['severity'] == 'temporary' 
    return 'icons/question.gif'
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
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end
end
