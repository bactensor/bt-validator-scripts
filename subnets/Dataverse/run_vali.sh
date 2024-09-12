#!/bin/bash
pm2 delete dataverse-validator
pm2 delete sn13-validator

cd data-universe
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

echo "MAKE SURE YOU ARE IN VENV"
echo "SCREENSHOT"
echo "python3 -m venv venv"
echo ". venv/bin/activate"
sleep 6

pm2 start --name dataverse-validator --interpreter python3 scripts/start_validator.py -- --pm2_name sn13-validator --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --axon.port 10824 --subtensor.chain_endpoint ws://REDACTED:9944

pm2 log
