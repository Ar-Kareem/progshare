tail -n 100 -f ./logs/nginx_logs/access.log | sed 's/^/nginx_acss: /' &
tail -n 100 -f ./logs/nginx_logs/error.log | sed 's/^/nginx_error: /' & 
tail -n 100 -f ./logs/redis/redis-server.log | sed 's/^/redis: /' & 
tail -n 100 -f ./logs/traefik_logs/traefik_access.json | sed 's/^/traefik_acss: /' & 
tail -n 100 -f ./logs/traefik_logs/traefik_logs.json | sed 's/^/traefik_logs: /'