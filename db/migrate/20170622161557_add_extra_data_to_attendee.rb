class AddExtraDataToAttendee < ActiveRecord::Migration[5.1]
  def change
    add_column :attendees, :extra_data, :jsonb, default: {}
  end
end
