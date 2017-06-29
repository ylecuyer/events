json.extract! user, :id, :email, :password, :password_confirmation, :created_at, :updated_at
json.url user_url(user, format: :json)
