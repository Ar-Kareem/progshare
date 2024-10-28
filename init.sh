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
else
    echo "Virtual environment does not exist. Creating and sourcing..."
    python3 -m venv ./venv
    source ./venv/bin/activate
    pip install --upgrade pip
fi
