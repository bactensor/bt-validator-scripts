#!/bin/bash
pm2 stop all
pm2 delete all

cd sturdy-subnet
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

pm2 start neurons/validator.py  --time --name rizzo10-sturdy --interpreter python3  -- --pm2_name rizzo10-sturdy-pm2 --netuid 10 --organic False  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace --axon.port 16274 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944

sleep 3
pm2 log
