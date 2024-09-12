#!/bin/bash
pm2 stop protein_validator
pm2 delete protein_validator

cd folding
source venv/bin/activate

# Source the .env file to load all environment variables
if [ -f .env ]; then
  set -a  # Automatically export all variables
  source .env
  set +a  # Stop automatically exporting variables

  # Now you can use the variables from the .env file
  echo "WALLET_NAME is $WALLET_NAME"
  echo "WALLET_HOTKEY_NAME is $WALLETHOTKEY"
else
  echo ".env file not found."
fi

git fetch 
git stash
git pull

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

pm2 start neurons/validator.py --name protein_validator --interpreter python3 --time -- \
  --name 25folding --netuid 25 --wallet.name $WALLET_NAME \
  --axon.port 16314 --wallet.hotkey $WALLETHOTKEY --logging.debug --logging.trace \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944

pm2 log protein_validator
