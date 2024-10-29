tail -n ${1-100} -f ./logs/nginx/access.log | sed 's/^/nginx_acss: /' &
tail -n ${1-100} -f ./logs/nginx/error.log | sed 's/^/nginx_error: /' & 
tail -n ${1-100} -f ./logs/nginx/cart-err.log | sed 's/^/uwsgi: /' & 
tail -n ${1-100} -f ./logs/nginx/flaskapp.log | sed 's/^/flaskapp: /' & 
tail -n ${1-100} -f ./logs/redis/redis-server.log | sed 's/^/redis: /' & 
tail -n ${1-100} -f ./logs/traefik_logs/traefik_access.json | sed 's/^/traefik_acss: /' & 
tail -n ${1-100} -f ./logs/traefik_logs/traefik_logs.json | sed 's/^/traefik_logs: /' &
sleep 0.2  # to wait for all tail to finish printing before returning prompt

# to be able to ctrl-c (looks worse)
# tail -n ${1-100} -f ./logs/nginx/access.log ./logs/nginx/error.log ./logs/nginx/cart-err.log ./logs/nginx/flaskapp.log ./logs/redis/redis-server.log ./logs/traefik_logs/traefik_access.json  ./logs/traefik_logs/traefik_logs.json

