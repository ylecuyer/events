class AddInvitationStatusToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_column :attendees, :invitation_status, :string
  end
end
