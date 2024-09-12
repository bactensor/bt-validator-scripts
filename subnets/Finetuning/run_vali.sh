#!/bin/bash
pm2 stop all
pm2 delete all

cd finetuning
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

python3 -m pip install -r requirements.txt
python3 -m pip install -e .


api_key=$WANDB_ACCESS_TOKEN; grep -qxF "export WANDB_ACCESS_TOKEN=$api_key" ~/.bashrc || sed -i "/^export WANDB_ACCESS_TOKEN=/d" ~/.bashrc && echo "export WANDB_ACCESS_TOKEN=$api_key" >> ~/.bashrc && source ~/.bashrc
echo "exporting WANDB_ACCESS_TOKEN key, ctrl-C and do source after this if new!!!!"
sleep 3

#04
pm2 start scripts/start_validator.py \
 --time \
 --name finetune-vali-updater \
 --interpreter python3 \
 -- \
 --pm2_name finetune-vali \
 --wallet.name $WALLET_NAME \
 --wallet.hotkey $WALLET_HOTKEY_NAME \
 --netuid 37 \
 --subtensor.chain_endpoint ws://REDACTED:9944 \
 --axon.port 16718 --logging.debug --logging.trace  

pm2 log
