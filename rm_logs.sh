echo "deleting all log contents..."
sleep 5s
# below command will delete contents of all logs. Explination of command, the ":|" is a dissapointed emoji thus all file contents are deleted
:| tee ./logs/nginx/access.log ./logs/nginx/error.log ./logs/nginx/cart-err.log ./logs/nginx/flaskapp.log ./logs/redis/redis-server.log ./logs/traefik_logs/traefik_access.json  ./logs/traefik_logs/traefik_logs.json
echo "All logs deleted"
