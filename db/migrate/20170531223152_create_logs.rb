class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :internal_id
      t.text :json

      t.timestamps
    end
  end
end
