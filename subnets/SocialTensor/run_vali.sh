#!/bin/bash
#NO GPU NEEDED

pm2 stop validator_nicheimage
pm2 stop auto-update

pm2 delete validator_nicheimage
pm2 delete auto-update

echo "screenshot and venv and run this again!!!!"
echo "python3 -m venv venv-sn23-social-niche"
echo "source venv-sn23-social-niche/bin/activate"
echo "sleeping 15"
sleep 15


cd NicheImage
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

python3 -m pip install -e .
python3 -m pip instsall -r requirements.txt


pip uninstall uvloop -y


pm2 start python3 --time --name "validator_nicheimage" -- -m neurons.validator.validator --netuid 23  --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug  \
  --axon.port 11023 \
  --subtensor.chain_endpoint ws://REDACTED:9944 

pm2 start auto_update.sh --name "auto-update" --cron-restart="0 * * * *" --attach

