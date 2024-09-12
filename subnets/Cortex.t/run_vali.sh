#!/bin/bash

pm2 stop cortex_validator
pm2 delete cortex_validator

# rm -rf ~/.bitttensor/miners/RIZZO/rizzo/netuid18/validator/wandb/*

cd cortex.t
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

echo "do venv"
sleep 5

git fetch
git stash
git pull
python3 -m pip install -e .

#sn18 api key
openai_api_key=$OPENAI_API_KEY_18; grep -qxF "export OPENAI_API_KEY=$openai_api_key" ~/.bashrc || sed -i "/^export OPENAI_API_KEY=/d" ~/.bashrc && echo "export OPENAI_API_KEY=$openai_api_key" >> ~/.bashrc && source ~/.bashrc

#anthropic
anthropic_api_key=$ANTHROPIC_API_KEY; grep -qxF "export ANTHROPIC_API_KEY=$anthropic_api_key" ~/.bashrc || sed -i "/^export ANTHROPIC_API_KEY=/d" ~/.bashrc && echo "export ANTHROPIC_API_KEY=$anthropic_api_key" >> ~/.bashrc && source ~/.bashrc


echo "do source ~/.bashrc if you updated Openai or Anthropic key, and re-run this script!"
sleep 3

pm2 start ./validators/validator.py --time --name cortex_validator --interpreter python3 -- \
  --netuid 18 \
  --subtensor.chain_endpoint ws://REDACTED:9944 \
  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME

pm2 log cortex_validator