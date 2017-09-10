# == Schema Information
#
# Table name: logs
#
#  id          :integer          not null, primary key
#  internal_id :string
#  json        :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  timestamp   :float
#  attendee_id :integer
#
# Indexes
#
#  index_logs_on_attendee_id  (attendee_id)
#
# Foreign Keys
#
#  fk_rails_...  (attendee_id => attendees.id)
#

class Log < ApplicationRecord
  belongs_to :attendee
end
