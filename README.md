
# Gettings started:

    git clone git@github.com:Ar-Kareem/progshare.git
    cd progshare

    chmod +x ./init.sh
    ./init.sh
    source ./venv/bin/activate

    docker compose up --build --remove-orphans --force-recreate -d

## other commands

RSYNC from pi:

    rsync -r --exclude "venv" --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/ ./progshare/

needed if volumes change:
        
    docker-compose rm

for dev:
    
    docker compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up --build --remove-orphans --force-recreate

for redis cli:

    docker exec -it redis redis-cli -p 4721

to edit redis .conf, need to own the file first:

    sudo chown master ./redis/redis.conf

