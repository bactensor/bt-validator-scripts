#!/bin/bash
#needs GPU 20GB



pm2 delete sn9_validator
pm2 delete pretraining_validator

cd pretraining
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

pm2 start --time --name pretraining_validator --interpreter python3 scripts/start_validator.py -- --pm2_name sn9_validator --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --netuid 9  --subtensor.chain_endpoint ws://REDACTED:9944  --axon.port 8143 && pm2 log

