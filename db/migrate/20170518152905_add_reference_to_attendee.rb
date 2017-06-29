class AddReferenceToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_column :attendees, :reference, :string
  end
end
