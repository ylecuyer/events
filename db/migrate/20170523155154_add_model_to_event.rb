class AddModelToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :model, :text
  end
end
