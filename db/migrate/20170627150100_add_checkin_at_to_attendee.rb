class AddCheckinAtToAttendee < ActiveRecord::Migration[5.1]
  def change
    add_column :attendees, :checkin_at, :timestamp
  end
end
