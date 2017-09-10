class CastAttendeeJsonToJson < ActiveRecord::Migration[5.1]
  def change
    change_column :logs, :json, 'jsonb USING CAST(json AS jsonb)'
  end
end
