class NgrokService
  def public_url
    response = Faraday.get 'http://ngrok:4040/api/tunnels/app'
    JSON.parse(response.body)['public_url']
  end
end
