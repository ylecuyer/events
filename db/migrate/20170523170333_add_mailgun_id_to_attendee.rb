class AddMailgunIdToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_column :attendees, :mailgun_id, :string
  end
end
