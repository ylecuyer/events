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

require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  test 'dummy attendee' do
    dummy_attendee = Attendee.dummy

    assert_equal 'DummyLastName', dummy_attendee.last_name
    assert_equal 'DummyFirstName', dummy_attendee.first_name
    assert_equal 'DUMMYX', dummy_attendee.reference
    assert_equal Category.dummy.attributes, dummy_attendee.category.attributes
    assert_equal Event.dummy.attributes, dummy_attendee.event.attributes
  end

  test 'full_name is first_name then last_name' do
    attendee = Attendee.new(first_name: 'Yoann', last_name: 'Lecuyer')
    assert_equal(attendee.full_name, 'Yoann Lecuyer')
  end

  test 'add reference when saving' do
    attendee = Attendee.new(first_name: 'Yoann', last_name: 'Lecuyer', email: 'yoann@example.com')
    attendee.event = events(:first)
    attendee.category = categories(:scac)
    attendee.save

    assert_not_empty attendee.reference
  end

  test 'icon for attendee without mailgun_id' do
    attendee = Attendee.where(id: 1).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/new.png', attendee.status_icon_name
  end

  test 'icon for attendee with mailgun_id but no logs' do
    attendee = Attendee.where(id: 2).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/hourglass.png', attendee.status_icon_name
  end

  test 'icon for attendee delivered' do
    attendee = Attendee.where(id: 3).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/accept.png', attendee.status_icon_name
  end

  test 'icon for attendee failed' do
    attendee = Attendee.where(id: 4).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/exclamation.png', attendee.status_icon_name
  end

  test 'icon for attendee accepted' do
    attendee = Attendee.where(id: 5).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/time.png', attendee.status_icon_name
  end

  test 'icon for attendee temp failure' do
    attendee = Attendee.where(id: 6).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/error.png', attendee.status_icon_name
  end

  test 'icon for attendee unknown status' do
    attendee = Attendee.where(id: 7).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'icons/question.gif', attendee.status_icon_name
  end

  test 'invitation status for attendee without log' do
    attendee = Attendee.where(id: 2).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'queued', attendee.invitation_status
  end

  test 'invitation status for attendee delivered' do
    attendee = Attendee.where(id: 3).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'delivered (2017-06-28 16:19:25 +0000) [250 / OK /  ]', attendee.invitation_status
  end

  test 'invitation status for attendee failure' do
    attendee = Attendee.where(id: 6).select('attendees.*, categories.name, logs.json as log').joins(:category).joins('LEFT JOIN logs ON logs.attendee_id = attendees.id').where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal 'failed (2017-06-28 16:19:35 +0000) [498 / No MX for latinmail.com / No MX for latinmail.com / retry in 600 seconds ]', attendee.invitation_status
  end

  test 'checkin attendee' do
    Timecop.freeze do
      attendee = attendees(:ylecuyer)

      attendee.checkin!

      assert_equal Time.now, attendee.checkin_at
    end
  end

  test 'query_delivered' do
    event = events(:first)
    
    timestamp_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('timestamp'))
    cast_timestamp_node = Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])
    max_cast_timestamp_node = Arel::Nodes::Max.new [Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])]
    event_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('event'))
    sub_query = Log.arel_table.project(max_cast_timestamp_node).where(Log.arel_table[:attendee_id].eq(Attendee.arel_table[:id]))

    delivered = event.attendees.with_logs
      .where(Arel::Nodes::Equality.new cast_timestamp_node, sub_query)
      .where(event_node.eq('delivered'))
      .count

    assert_equal 1, delivered
  end

  test 'query_failed' do
    event = events(:first)
    
    timestamp_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('timestamp'))
    cast_timestamp_node = Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])
    max_cast_timestamp_node = Arel::Nodes::Max.new [Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])]
    event_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('event'))
    severity_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('severity'))
    sub_query = Log.arel_table.project(max_cast_timestamp_node).where(Log.arel_table[:attendee_id].eq(Attendee.arel_table[:id]))

    failed = event.attendees.with_logs
      .where(Arel::Nodes::Equality.new cast_timestamp_node, sub_query)
      .where(event_node.eq('failed'))
      .where(severity_node.eq('permanent'))
      .count

    assert_equal 1, failed
  end

  test 'query_warning' do
    event = events(:first)
    
    timestamp_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('timestamp'))
    cast_timestamp_node = Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])
    max_cast_timestamp_node = Arel::Nodes::Max.new [Arel::Nodes::NamedFunction.new('CAST', [timestamp_node.as('FLOAT')])]
    event_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('event'))
    severity_node = Arel::Nodes::InfixOperation.new('->>', Log.arel_table[:json], Arel::Nodes::build_quoted('severity'))
    sub_query = Log.arel_table.project(max_cast_timestamp_node).where(Log.arel_table[:attendee_id].eq(Attendee.arel_table[:id]))

    warning = event.attendees.with_logs
      .where(Arel::Nodes::Equality.new cast_timestamp_node, sub_query)
      .where(event_node.eq('failed'))
      .where(severity_node.eq('temporary'))
      .count

    assert_equal 1, warning
  end
    

  # test "the truth" do
  #   assert true
  # end
end
