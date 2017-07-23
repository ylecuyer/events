class Event < ApplicationRecord
  has_many :attendees
  has_many :categories

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/noimagefound.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :name, presence: true, uniqueness: true
  validates :start, :venue, presence: true

  def tag
    "Event-#{id}"
  end

  def self.dummy
    event = Event.new
    event.name = "Fête nationale"
    event.venue = "Residence de France"
    event.start = "2017-07-14 12:30"
    event
  end
end
