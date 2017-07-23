require 'test_helper'

class FakeTicketValidatorServiceTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionDispatch::TestProcess

  test "Return number of rows imported" do
    event = events(:first)
    category = categories(:scac)

    csv_importer = CsvImporterService.new(send_invites: true, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA.csv'))
    count = csv_importer.import

    assert_equal 1, count
  end

  test "Wrong header" do
    event = events(:first)
    category = categories(:scac)

    assert_raise RuntimeError, "Missing field: first_name" do
      csv_importer = CsvImporterService.new(send_invites: false, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA_wrong_header.csv'))
      csv_importer.import
    end
  end

  test "malformed csv" do
    event = events(:first)
    category = categories(:scac)

    assert_raise CSV::MalformedCSVError, "Unclosed quoted field on line 2." do
      csv_importer = CsvImporterService.new(send_invites: false, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA_malformed.csv'))
      csv_importer.import
    end
  end

  test "two emails in row" do
    event = events(:first)
    category = categories(:scac)

    assert_raise RuntimeError, "email(ylecuyer@example.com;second@example.com) is malformed in row #2" do
      csv_importer = CsvImporterService.new(send_invites: false, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA_two_mails.csv'))
      csv_importer.import
    end
  end

  test "Send invite while importing csv" do
    event = events(:first)
    category = categories(:scac)

    assert_enqueued_jobs 1 do
      csv_importer = CsvImporterService.new(send_invites: true, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA.csv'))
      csv_importer.import
    end
  end

  test "Import csv without sending invites" do
    event = events(:first)
    category = categories(:scac)

    assert_no_enqueued_jobs do
      csv_importer = CsvImporterService.new(send_invites: false, event_id: event.id, category_id: category.id, file: File.new('test/fixtures/files/DUA.csv'))
      csv_importer.import
    end
  end

end
