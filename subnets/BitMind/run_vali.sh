#!/bin/bash
#vram 24
pm2 stop all
pm2 delete all

cd bitmind-subnet
source venv-sn34-bitmind_venv/bin/activate

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

git checkout main
git fetch
git stash
git pull

export PIP_NO_CACHE_DIR=1
python3 -m pip install -e .

pm2 start neurons/validator.py --interpreter python3 --time --name bitmind-validator -- \
  --netuid 34 \
  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 

pm2 log

#sn34's wandb:
#grep -qxF 'export WANDB_API_KEY=REDACTED' ~/.bashrc || echo 'export WANDB_API_KEY=REDACTED' >> ~/.bashrc
