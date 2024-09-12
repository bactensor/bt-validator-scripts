#!/bin/bash
#no gpu

pm2 stop all
pm2 delete all

cd code
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

sudo docker rm mistral-instruct

sudo docker run -d -p 8028:8000  --gpus device=0 --ipc host --name mistral-instruct docker.io/vllm/vllm-openai:latest --model thesven/Mistral-7B-Instruct-v0.3-GPTQ --max-model-len 8912 --quantization gptq --dtype half --gpu-memory-utilization 0.5

pm2 start --time --name masa_validator --interpreter python3 neurons/validator.py -- \
  --netuid 42 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME \
  --axon.ip 123.123.123.123 \
  --axon.port 32583 \
  --subtensor.network local \
  --subtensor.chain_endpoint ws://REDACTED:9944 \
  --logging.trace

pm2 log