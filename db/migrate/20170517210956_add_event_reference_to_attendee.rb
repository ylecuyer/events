class AddEventReferenceToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_reference :attendees, :event, foreign_key: true
  end
end
