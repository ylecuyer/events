set -m

echo "Starting ngrok"
./ngrok start -config ngrok.yml app &

echo "Ngrok started waiting 3 seconds..."
sleep 5

URL=$(curl -s http://localhost:4040/api/tunnels/app | jq -r .public_url)

echo "Public url: $URL"

fg
