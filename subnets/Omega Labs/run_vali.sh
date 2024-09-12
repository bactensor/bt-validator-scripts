#!/bin/bash
pm2 delete all

cd omegalabs-bittensor-subnet
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
git pull

python3 -m pip install -e .

pm2 start omega_labs_validator.py --time --name rizzo4 --interpreter python3  -- --netuid 24 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace --axon.port 6262 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944

sleep 3
pm2 log


