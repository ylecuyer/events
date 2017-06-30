class RemoveIsProcessingStatusUpdateToAttendee < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendees, :is_processing_status_update
  end
end
