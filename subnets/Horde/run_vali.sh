#!/bin/bash
#no GPU

# sudo apt update

source venv/bin/activate
# sudo docker-compose down

sudo docker compose up -d

echo "doing this: sudo docker-compose logs --follow validator-runner"
echo "doing this: sudo docker-compose logs --follow validator-runner"
echo "doing this: sudo docker-compose logs --follow validator-runner"

sudo docker compose logs --follow validator-runner


