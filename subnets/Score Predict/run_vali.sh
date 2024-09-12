#!/bin/bash
#no gpu

pm2 stop score_predict_validator
pm2 stop sn44-autoupdater
pm2 delete score_predict_validator
pm2 delete sn44-autoupdater

cd score-predict

git checkout main
git fetch
git stash
git pull

deactivate

source venv-sn44-score-predict/bin/activate

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

python3 -m pip install -r requirements.txt

pm2 start python3 --time --name score_predict_validator -- \
  neurons/validator.py \
  --netuid 44 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --subtensor.network local \
  --logging.trace \
  --logging.debug \
  --axon.port 51225 \
  --subtensor.chain_endpoint ws://REDACTED:9944

 
pm2 start validator_auto_update.sh --name sn44-autoupdater --interpreter bash -- validator

pm2 log score_predict_validator

