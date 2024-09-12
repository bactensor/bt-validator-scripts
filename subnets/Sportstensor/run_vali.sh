#!/bin/bash

pm2 stop all
pm2 delete all

cd sportstensor
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

git checkout main
git fetch
git stash
git pull

#change python to python3 as needed
TARGET_FILE="vali_auto_update.sh"
sed -i '/python3/!s/\bpython\b\([^3]\|$\)/python3\1/g' "$TARGET_FILE"

pm2 start $TARGET_FILE --time --name "Sportstensor-validator" -- \
  --netuid 41 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 \
  --axon.port "54535" \
  --logging.trace 

pm2 log