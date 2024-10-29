#!/bin/sh

rsync -r --rsync-path="sudo rsync" master@192.168.100.243:/home/master/progshare/redis/dump.rdb ./z_$(date +%Y_%m_%d_%H_%M).rdb
