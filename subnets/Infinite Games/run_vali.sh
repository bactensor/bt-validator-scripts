#!/bin/bash

pm2 stop infinite_games_validator
pm2 delete infinite_games_validator

cd infinite_games 
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

sleep 10

git checkout main
git fetch
git stash
git pull

python3 -m pip install -r requirements.txt

export USE_TORCH=1

pm2 start neurons/validator.py \
 --time \
 --name infinite_games_validator \
 --interpreter python3 \
 -- \
 --wallet.name $WALLET_NAME \
 --wallet.hotkey $WALLET_HOTKEY_NAME \
 --netuid 6 \
 --subtensor.chain_endpoint ws://REDACTED:9944 \
 --axon.port 16709 --logging.debug --logging.trace  

pm2 log infinite_games_validator
