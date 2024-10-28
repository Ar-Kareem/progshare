
# Gettings started:

    git clone https://github.com/Ar-Kareem/progshare.git
    cd progshare

    chmod +x ./init.sh
    ./init.sh
    source ./venv/bin/activate

    docker compose up --build --remove-orphans --force-recreate -d

    (if you want the local redis port open)
    docker compose -f docker-compose.yml -f docker-compose-redisport.yml up --build --remove-orphans --force-recreate -d

## other commands

vscode can view DB if you ssh into the server and connect to redis using `Database Client JDBC` extension.




RSYNC DB from pi:

    rsync -r --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/redis/dump.rdb ./dump.rdb

RSYNC directory from pi: (shouldn't need to use this)

    rsync -r --exclude "venv" --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/ ./progshare/

stop -> pull -> start:

    docker compose stop; git pull; docker compose -f docker-compose.yml -f docker-compose-redisport.yml up --build --remove-orphans --force-recreate -d

needed if volumes change:
        
    docker-compose rm

for dev:
    
    docker compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up --build --remove-orphans --force-recreate

for redis cli:

    docker exec -it redis redis-cli -p 4721

to edit redis .conf or read .log, need to own the file first:

    sudo chown master ./redis/redis.conf
    sudo chmod +r redis/.log 

