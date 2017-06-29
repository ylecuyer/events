class AddAttendeeToLog < ActiveRecord::Migration[5.0]
  def change
    add_reference :logs, :attendee, foreign_key: true
  end
end
