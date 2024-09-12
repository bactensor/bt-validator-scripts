#!/bin/bash
pm2 stop all
pm2 delete all

cd NASChain
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
git reset --hard origin/main
pkill -9 -f "validator"
git stash
git pull
python3 -m pip install -r requirements.txt
ptyhon3 -m pip install -r requirements-compute.txt
python3 -m pip install -e .

# securely pull down .env here etc if needed, source bashrc if needed etc

export WANDB_API_KEY=$WANDB_API_KEY
#local 02
pm2 start neurons/validator.py --time --restart-delay 15000 --interpreter python3 --name rizzo31NASChain -- \
  --netuid 31  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME  \
  --logging.debug --logging.trace \
  --axon.port 5491 --dht.port 5492 --dht.announce_ip 123.123.123.123  \
  --genomaster.ip http://51.161.12.128  --genomaster.port 5000 \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 

pm2 log 
