#!/bin/bash
pm2 stop all
pm2 delete all

cd dippy-bittensor-subnet
source venv/bin/activate

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
git stash
git pull

python3 -m pip install -e .

pip install --upgrade transformers
pip install --upgrade torch
pip install --upgrade torchaudio

#data 02 
pm2 start scripts/start_validator.py --interpreter python3 --time --name dippy-validator -- --neuron.auto_update --netuid 11 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace --axon.port 16334 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944

pm2 log