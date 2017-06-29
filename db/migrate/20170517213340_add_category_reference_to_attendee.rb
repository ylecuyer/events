class AddCategoryReferenceToAttendee < ActiveRecord::Migration[5.0]
  def change
    add_reference :attendees, :category, foreign_key: true
  end
end
