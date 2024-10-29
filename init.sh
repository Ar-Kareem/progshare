#!/bin/bash

echo "init script for secrets. Can run multiple times."

ENV_FILE="./app/.env"
if [ -f "$ENV_FILE" ]; then
    echo "Environment file exists"
else
    echo "Environment file does not exist. Creating..."
    echo "SECRET_KEY=$(python -c 'import secrets; print(secrets.token_hex())')" > $ENV_FILE
fi

if [ -d "./venv" ]; then
    echo "Virtual environment exists. Sourcing..."
    source ./venv/bin/activate
    echo "Ensure python and pip are sourced from virtual environment"
    which python
    which pip
else
    echo "Virtual environment does not exist. Creating and sourcing..."
    python3 -m venv ./venv
    source ./venv/bin/activate
    echo "Ensure python and pip are sourced from virtual environment"
    which python
    which pip
    pip install --upgrade pip
fi
echo "Installing requirements"
pip install -r ./app/requirements.txt | grep -v 'already satisfied'

echo "bugfix for redis logs permission issue"  # see https://unix.stackexchange.com/a/408510
mkdir -p logs/redis
touch logs/redis/redis-server.log
chmod 660 logs/redis/redis-server.log

echo "make uwsgi logs readable"
mkdir -p logs/nginx
touch logs/nginx/cart-err.log
chmod 660 logs/nginx/cart-err.log
