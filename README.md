docker compose up --build
docker compose up --build --remove-orphans --force-recreate
docker-compose rm

for redis cli:
    docker exec -it redis redis-cli -p 4721

to edit redis .conf, need to own the file first:
    sudo chown master ./redis/redis.conf