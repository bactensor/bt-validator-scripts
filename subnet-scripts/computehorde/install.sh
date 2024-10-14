#!/bin/bash
#no GPU

if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

if [ -d ~/.bittensor/subnets/computehorde/ ]; then
    cd ~/.bittensor/subnets/computehorde/
else
    echo "Directory ~/.bittensor/subnets/computehorde/ does not exist. Exiting."
    exit 1
fi
sudo docker compose down

sudo docker compose up -d