#!/bin/bash
pm2 stop all
pm2 delete all

cd MyShell-TTS-Subnet
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

pm2 start scripts/start_validator.py  --time --name finetune-vali-updater --interpreter python3  -- --pm2_name finetune-vali --netuid 3  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace \
  --axon.ip 123.123.123.123 \
  --axon.port 6273 \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944

#old manual local datacenter 02
#pm2 start neurons/validator.py --time --name sn3 --interpreter python3  -- --netuid 3  --wallet.name RIZZO --wallet.hotkey rizzo --logging.debug --logging.trace --axon.port 6275 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944

sleep 3
pm2 log


