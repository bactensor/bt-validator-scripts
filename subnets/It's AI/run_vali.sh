#!/bin/bash

sudo apt update #because a command below needs sudo

pm2 stop all
pm2 delete all

cd llm-detection
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

#python3 -m pip install -r requirements.txt   #SOMETIMES NOT NEEDED
python3 -m pip install -e .
python3 -m pip uninstall mathgenerator -y
python3 -m pip install git+https://github.com/synapse-alpha/mathgenerator.git

chmod +x run.sh

apt update
apt install lshw

#sudo nohup ollama serve&

pgrep ollama | sudo xargs kill

curl -fsSL https://ollama.com/install.sh | sh

pm2 start --name ollama "ollama serve"

#locl datacenter 02
pm2 start run.sh --time --name llm_detection_validators_autoupdate -- --netuid 32 --neuron.device cuda:0 --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --logging.debug --logging.trace --axon.port 6269 --subtensor.network local --subtensor.chain_endpoint ws://REDACTED:9944

#sleep 3
pm2 log


