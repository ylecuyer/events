json.extract! attendee, :id, :first_name, :last_name, :email, :created_at, :updated_at
json.url attendee_url(attendee, format: :json)
