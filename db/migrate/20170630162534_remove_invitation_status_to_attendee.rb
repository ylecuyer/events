class RemoveInvitationStatusToAttendee < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendees, :invitation_status
  end
end
