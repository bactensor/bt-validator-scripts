#!/bin/bash
#no gpu

pm2 stop all
pm2 delete all

cd coldint_validator
git checkout main
git fetch
git stash
git pull

deactivate

source venv-sn29-coldint_venv/bin/activate

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

python3 -m pip install packaging
python3 -m pip install wheel
python3 -m pip install torch

python3 -m pip install -r requirements.txt

python3 -m pip install -e .

pm2 start --time --name net29-vali-updater --interpreter python3 scripts/start_validator.py -- \
  --pm2_name net29-vali \
  --netuid 29 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --subtensor.network local \
  --logging.trace \
  --axon.port 51532 \
  --subtensor.chain_endpoint ws://REDACTED:9944
  

pm2 start ~/r-sn29m.sh --interpreter bash

pm2 log