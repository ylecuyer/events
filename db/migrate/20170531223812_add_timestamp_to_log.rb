class AddTimestampToLog < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :timestamp, :float
  end
end
