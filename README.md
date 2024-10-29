Very simple backend that supports settings and gettings public arbitrary strings of text (limited to 16KB). 

This project is utilized in https://github.com/Ar-Kareem/PythonDiceWeb

Uses three docker containers: 

1. Reverse Proxy: Traefik [ports are exposed to internet]

2. The server: nginx + uwsgi + Python Flask [nginx implements rate limiting per ip]

3. Database: Redis

# Gettings started:

    git clone https://github.com/Ar-Kareem/progshare.git
    cd progshare

    chmod +x ./init.sh
    ./init.sh
    source ./venv/bin/activate

    docker compose up --build --remove-orphans --force-recreate -d

    (if you want the local redis port open)
    docker compose -f docker-compose.yml -f docker-compose-redisport.yml up --build --remove-orphans --force-recreate -d

## Requirements:

- All above commands ran successfully
- The domain `$DOMAIN` in the `./.env` file points to the machine running the docker container (both ports `80` and `443`).
    - Example for home-server using sqaurespace domain: 
        - Go to squarespace `DNS Settings` and add a `Custom record` which makes `$DOMAIN` point to [your ip](https://api.ipify.org/?format=text)
        - make sure [your ip](https://api.ipify.org/?format=text) router forwards incoming traffic from ports `80` and `443` to the static-ip of the device running the docker container.
        - To check run `dig $DOMAIN +nostats +nocomments +nocmd` and make sure domain points to server-ip.

## Health Check

(IGNORE SSL) Run below. should be `Is Alive: yes`.

    chmod +x ./healthcheck.sh ; ./healthcheck.sh

(ENSURE SSL IS ON) Run below. should be `Is Alive: yes`.

    chmod +x ./healthcheck_ssl.sh ; ./healthcheck_ssl.sh


## Database Backup

You should periodically run the `.sh` or `.ps` script in  `./db_backups/` to make backups of the redis database.

## Read logs

You should check logs to make sure no critical errors happened. Run the following and look at the output:

    chmod +x tail_logs.sh; ./tail_logs.sh

## other commands

vscode can view DB if you ssh into the server and connect to redis using `Database Client JDBC` extension.




RSYNC DB from pi:

    rsync -r --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/redis/dump.rdb ./dump.rdb

RSYNC directory from pi: (shouldn't need to use this)

    rsync -r --exclude "venv" --exclude ".git" --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/ ./progshare/

Check which docker containers are running: `docker ps`

stop and remove containers: `docker compose down`

stop -> pull -> start:

    docker compose stop; git pull; docker compose -f docker-compose.yml -f docker-compose-redisport.yml up --build --remove-orphans --force-recreate -d

needed if volumes change:
        
    docker-compose rm

for dev:
    
    docker compose -f ./docker-compose.yml -f ./docker-compose-dev.yml up --build --remove-orphans --force-recreate

for redis cli:

    docker exec -it redis redis-cli -p 4721

to edit redis .conf, need to own the file first:

    sudo chown master ./redis/redis.conf

to delete all logs

    sudo rm -rf ./logs ; chmod +x init.sh ; ./init.sh
