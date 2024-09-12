#!/bin/bash

pm2 stop all
pm2 delete all 

echo "screenshot and venv and run this again!!!!"
echo "python3 -m venv venv-sn26-tensoralchemy"
echo "source venv-sn26-tensoralchemy/bin/activate"
echo "sleeping 15"
sleep 15


cd TensorAlchemy
source venvs/TensorAlchemy/bin/activate

# Source the .env file to load all environment variables
if [ -f .env ]; then
  set -a  # Automatically export all variables
  source .env
  set +a  # Stop automatically exporting variables

  # Now you can use the variables from the .env file
  echo "WALLET_NAME is $WALLET_NAME"
  echo "WALLET_HOTKEY_NAME is $WALLET_HOTKEY_NAME"
else
  echo ".env file not found."
fi

git fetch
git reset --hard origin/main
pkill -9 -f "validator"
git stash
git pull

python3 -m pip install -r requrements.txt
python3 -m pip install -e .

#sudo apt-get update && sudo apt-get install python3.10-venv

#python3.10 -m venv ~/venvs/TensorAlchemy && source ~/venvs/TensorAlchemy/bin/activate && pip install wheel && pip install --upgrade setuptools

export OPENAI_API_KEY=$OPENAI_API_KEY_26

wandb login REDACTED


#sn26 api key
api_key=$OPENAI_API_KEY_26; grep -qxF "export OPENAI_API_KEY=$api_key" ~/.bashrc || sed -i "/^export OPENAI_API_KEY=/d" ~/.bashrc && echo "export OPENAI_API_KEY=$api_key" >> ~/.bashrc && source ~/.bashrc

echo "do source ~/.bashrc if you updated Openai key, and re-run this script!"
sleep 3

#local 91
pm2 start neurons/validator/main.py --time --restart-delay 15000 --interpreter python3 --name TensorAlchemy_validator -- --netuid 26 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME  --alchemy.device cuda:0  --logging.debug --logging.trace \ 
  --axon.port 19647 \ 
  --subtensor.network finney \
  --subtensor.chain_endpoint ws://REDACTED:9944


pm2 log
