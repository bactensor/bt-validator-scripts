#!/bin/bash
#no GPU

export $(awk '!/^#/ && /=/ {print}' .env)

cd ~/.bittensor/subnets/computehorde/
sudo docker compose down

sudo docker compose up -d