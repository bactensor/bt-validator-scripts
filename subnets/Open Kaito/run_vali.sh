#!/bin/bash

pm2 stop openkaito_validator_autoupdate
pm2 stop openkaito_validator_main_process

pm2 delete openkaito_validator_autoupdate
pm2 delete openkaito_validator_main_process

cd openkaito
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

python3 -m pip install asyncio #Greg added
python3 -m pip install bittensor==6.12.0 #Greg added

# Rhef, action here --> we securely pull down this file with sshpass and sftp server: dotenv-sn5-open-kaito.env and overwrite: ~/.bittensor/subnets/openkaito/.env

#sn5 api key #WARNING THIS SCRIPT DOESN'T SEEM TO BE WORKING, do manually
api_key=$OPENAI_API_KEY_5; grep -qxF "export OPENAI_API_KEY=$api_key" ~/.bashrc || sed -i "/^export OPENAI_API_KEY=/d" ~/.bashrc && echo "export OPENAI_API_KEY=$api_key" >> ~/.bashrc && source ~/.bashrc

echo "do source ~/.bashrc if you updated Openai key, and re-run this script!"
echo "do venv and get bittensor on the latest, in venv"
echo "python3 -m venv venvrizzo5"
echo ". venvrizzo5/bin/activate"
echo "Screenshot the aboe VENV and ALSO do the bittensor on latest inside the venv"
sleep 5

pm2 start run.sh --time --name openkaito_validator -- --netuid 5 --axon.port 16525 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace

sleep 3
pm2 log