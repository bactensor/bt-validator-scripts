#!/bin/bash
pm2 stop losicnet-validator
pm2 delete losicnet-validator

cd LogicNet
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

echo "screenshot and do each line CAREFULLY:"
echo "pm2 list (it should be empty if you're starting a fresh run)"
echo "python3 -m venv venv-vllm"
echo ". vevenv-vllm/bin/activate"
echo "INSTALL THIS NOW"
echo "pip install vllm"
echo "then manually do this: "
echo ' pm2 start "vllm serve Qwen/Qwen2-7B-Instruct --port 8000 --host 0.0.0.0" --name sn35-vllm '
echo "then deactivate that venv with deactivate, "
echo "and then activate the BELOW 2nd VENV for main, and THEN re-run this script (PM2 starts at end):"
echo "python3 -m venv venv-main"
echo ". venv-main/bin/activate"
echo "sleeping for 15..."
echo "^^^^^^^^^^^^^^^^^^^^"
sleep 15


pm2 start python3 --time --name losicnet-validator -- neurons/validator/validator.py \
  --netuid 35 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 \
  --axon.port "6543" \
  --llm_client.base_url http://localhost:8000/v1 \ # vLLM server base url
  --llm_client.model Qwen/Qwen2-7B-Instruct \ # vLLM model name
  --logging.debug  # Optional: Enable debug logging

pm2 log