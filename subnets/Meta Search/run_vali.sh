#!/bin/bash
#needs GPU
pm2 stop all
pm2 delete all

cd smart-scrape
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
pip3 install -r requirements.txt
pip3 install -e .

#sn22 api key
api_key=$OPENAI_API_kEY_22; grep -qxF "export OPENAI_API_KEY=$api_key" ~/.bashrc || sed -i "/^export OPENAI_API_KEY=/d" ~/.bashrc && echo "export OPENAI_API_KEY=$api_key" >> ~/.bashrc && source ~/.bashrc

echo "do source ~/.bashrc if you updated Openai key, and re-run this script!"
sleep 3


pm2 start run.sh --time--name smart_scrape_validators -- --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --netuid 22 --subtensor.chain_endpoint ws://REDACTED:9944 --axon.port 28654 ; pm2 log


