RSYNC from pi:
    rsync -r --exclude "venv" --exclude ".git" --rsync-path="sudo rsync" master@192.168.100.243:/home/master/backend/ ./backend/

To run just run (remove -d to keep):
    docker compose up --build --remove-orphans --force-recreate -d
    (needed if volumes change):
        docker-compose rm

for dev:
    docker compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up --build --remove-orphans --force-recreate

for redis cli:
    docker exec -it redis redis-cli -p 4721

to edit redis .conf, need to own the file first:
    sudo chown master ./redis/redis.conf

