#!/bin/bash
#no gpu

pm2 stop all
pm2 delete all

cd Graphite-Subnet

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

deactivate

# python3.10 -m venv venv-sn43-graphite

source venv-sn43-graphite/bin/activate

export PIP_NO_CACHE_DIR=1

pip install -r requirements.txt
python3 -m pip install -e .

pm2 start --time --name rizzo-sn43-graphite-vali --interpreter python3 neurons/validator.py -- \
  --netuid 43 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 \
  --axon.port 51534 \
  --logging.trace \
  --organic False

pm2 log