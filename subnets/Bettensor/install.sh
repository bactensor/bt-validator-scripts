#!/bin/bash
git clone https://github.com/bettensor/bettensor.git
cp .env bettensor/.env

cd bettensor

sudo apt-get update && sudo apt-get install python3.10-venv

python3.10 -m venv venv
source venv/bin/activate

wandb login REDACTED

pip install -e .
pip install -r requirements.txt
sudo apt-get install -y npm jq
sudo npm install -g pm2
