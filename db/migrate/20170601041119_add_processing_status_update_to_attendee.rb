class AddProcessingStatusUpdateToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_column :attendees, :is_processing_status_update, :boolean, default: false
  end
end
