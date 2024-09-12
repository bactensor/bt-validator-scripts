#!/bin/bash
git clone https://github.com/TensorAlchemy/TensorAlchemy
cp .env TensorAlchemy/.env

cd TensorAlchemy

apt-get update 
apt-get install python3.10-venv 

python3.10 -m venv venvs/TensorAlchemy
source venvs/TensorAlchemy/bin/activate

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

pip install wheel
pip install --upgrade setuptools

export OPENAI_API_KEY=$OPENAI_API_KEY_26

wandb login REDACTED

python3 -m pip install -r requirements.txt
python3 -m pip install -e .
python3 -m pip install loguru

