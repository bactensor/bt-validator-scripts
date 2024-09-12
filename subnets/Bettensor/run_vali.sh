#!/bin/bash
pm2 stop all
pm2 delete all

cd bettensor
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

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

pm2 list
pm2 save --force

source scripts/start_neuron.sh \
  --axon.port 54121 \
  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --validator \
  --disable-auto-update \
  --logging.level trace \
  --network ws://REDACTED:9944 \

pm2 log