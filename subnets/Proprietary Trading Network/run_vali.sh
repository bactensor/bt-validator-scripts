#!/bin/bash



pm2 stop all
pm2 delete all

cd proprietary-trading-network
source venv/bin/activate
ulimit -n 100000

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


# git pull
# rm -rf venv
# python3 -m venv venv

export PIP_NO_CACHE_DIR=1
# pip3 install -r requirements.txt
# pip3 install -e .

pm2 start run.sh --time --name proprietary_validator  -- --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --netuid 8 --subtensor.chain_endpoint ws://REDACTED:9944 --logging.debug --autosync
# $ pm2 start run.sh --name sn8 -- --wallet.name <wallet> --wallet.hotkey <validator> --netuid 8 [--start-generate] [--autosync]


pm2 log 

