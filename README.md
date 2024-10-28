

To run just run:
    docker compose up

if not correctly updating:
    docker compose up --build --remove-orphans --force-recreate
    more (only needed if volumes change):
        docker-compose rm

for dev:
    docker compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up --build --remove-orphans --force-recreate

for redis cli:
    docker exec -it redis redis-cli -p 4721

to edit redis .conf, need to own the file first:
    sudo chown master ./redis/redis.conf

