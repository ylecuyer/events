class AddEventReferenceToCategory < ActiveRecord::Migration[5.0]
  def change
    add_reference :categories, :event, foreign_key: true
  end
end
