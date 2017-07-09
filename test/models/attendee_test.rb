require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
 
  test "full_name is first_name then last_name" do
    attendee = Attendee.new(first_name: "Yoann", last_name: "Lecuyer")
    assert_equal(attendee.full_name, "Yoann Lecuyer")
  end

  test "add reference when saving" do
    attendee = Attendee.new(first_name: "Yoann", last_name: "Lecuyer", email: "yoann@example.com")
    attendee.event = events(:first)
    attendee.category = categories(:scac)
    attendee.save
    
    assert_not_empty attendee.reference
  end

  test "icon for attendee without mailgun_id" do
    attendee = Attendee.where(id: 1).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/new.png", attendee.status_icon_name
  end

  test "icon for attendee with mailgun_id but no logs" do
    attendee = Attendee.where(id: 2).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/hourglass.png", attendee.status_icon_name
  end

  test "icon for attendee delivered" do
    attendee = Attendee.where(id: 3).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/accept.png", attendee.status_icon_name
  end

  test "icon for attendee failed" do
    attendee = Attendee.where(id: 4).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/exclamation.png", attendee.status_icon_name
  end

  test "icon for attendee accepted" do
    attendee = Attendee.where(id: 5).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/time.png", attendee.status_icon_name
  end

  test "icon for attendee temp failure" do
    attendee = Attendee.where(id: 6).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/error.png", attendee.status_icon_name
  end

  test "icon for attendee unknown status" do
    attendee = Attendee.where(id: 7).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "icons/question.gif", attendee.status_icon_name
  end

  test "invitation status for attendee without log" do
    attendee = Attendee.where(id: 2).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "queued", attendee.invitation_status
  end

  test "invitation status for attendee delivered" do
    attendee = Attendee.where(id: 3).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "delivered (2017-06-28 16:19:25 +0000) [250 / OK /  ]", attendee.invitation_status
  end

  test "invitation status for attendee failure" do
    attendee = Attendee.where(id: 6).select('attendees.*, categories.name, logs.json as log').joins(:category).joins("LEFT JOIN logs ON logs.attendee_id = attendees.id").where("(cast(logs.json->>'timestamp' as float) = (select max(cast(json->>'timestamp' as float)) from logs where attendee_id = attendees.id) OR logs.json IS NULL)").first
    assert_equal "failed (2017-06-28 16:19:35 +0000) [498 / No MX for latinmail.com / No MX for latinmail.com / retry in 600 seconds ]", attendee.invitation_status
  end

  # test "the truth" do
  #   assert true
  # end
end
