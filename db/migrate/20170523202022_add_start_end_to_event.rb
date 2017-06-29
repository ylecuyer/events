class AddStartEndToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
  end
end
