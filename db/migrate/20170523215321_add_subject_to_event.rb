class AddSubjectToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :subject, :string
  end
end
