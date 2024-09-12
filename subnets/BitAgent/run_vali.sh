#!/bin/bash
sudo service docker start
pm2 stop all
pm2 delete all

cd bitagent_subnet
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
python3 -m pip install -r requirements.txt
python3 -m pip install -e .

pm2 start run.sh --name bitagent_validators -- --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --netuid 20 --logging.debug --subtensor.chain_endpoint ws://REDACTED:9944 --axon.port 8105 --neuron.sample_size 60 --axon.ip 123.123.123.123 --neuron.device cpu

pm2 log