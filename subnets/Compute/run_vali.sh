#!/bin/bash

pm2 stop all
pm2 delete all

cd Compute-Subnet
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

#rm database.db
git fetch
git stash
git pull
python3 -m pip install -r requirements.txt
python3 -m pip install -e .
#python3 -m pip install -r requirements-compute.txt
# python3 -m pip install -e .

pm2 start neurons/validator.py  --time --restart-delay 15000 --name compute_validator --interpreter python3  -- --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --netuid 27 --axon.port 18748  --auto_update yes --logging.trace --logging.debug --blacklisted.hotkeys "[]" \
 --subtensor.chain_endpoint ws://REDACTED:9944 

pm2 log
