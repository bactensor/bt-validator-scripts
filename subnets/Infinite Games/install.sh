#!/bin/bash
git clone https://github.com/amedeo-gigaver/infinite_games.git 
cp .env infinite_games/.env

cd infinite_games
python3 -m venv venv
source venv/bin/activate

# Source the .env file to load all environment variables
if [ -f .env ]; then
  set -a  # Automatically export all variables
  source .env
  set +a  # Stop automatically exporting variables
else
  echo ".env file not found."
fi

python3 -m pip install -r requirements.txt

export USE_TORCH=1
#export GRAFANA_KEY=

#sn37 api key #WARNING THIS SCRIPT DOESN'T SEEM TO BE WORKING, do manually
api_key=$WANDB_ACCESS_TOKEN; grep -qxF "export WANDB_ACCESS_TOKEN=$api_key" ~/.bashrc || sed -i "/^export WANDB_ACCESS_TOKEN=/d" ~/.bashrc && echo "export WANDB_ACCESS_TOKEN=$api_key" >> ~/.bashrc && source ~/.bashrc
echo "exporting WANDB_ACCESS_TOKEN key, do source after this!  source ~/.bashrc "
