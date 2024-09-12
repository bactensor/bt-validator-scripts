#!/bin/bash
pm2 stop all
pm2 delete all

cd BitAds.ai
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

pip install -r requirements.txt

pm2 start run_validator_auto_update.py --log-date-format "HH:mm:ss.SSS MM-DD-YY Z" --time --restart-delay 15000 --interpreter python3 --name BitAds_validator -- --netuid 16   --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME  --subtensor.chain_endpoint ws://REDACTED:9944 --logging.debug --logging.trace --axon.port 26842

pm2 log 