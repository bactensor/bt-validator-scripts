#!/bin/bash
git clone https://github.com/neuralinternet/Compute-Subnet.git 
cp .env Compute-Subnet/.env

cd Compute-Subnet
python3 -m venv venv
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

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

grep -qxF "export WANDB_API_KEY=$NEW_WANDB_API_KEY" ~/.bashrc || (sed -i "s/export WANDB_API_KEY=$OLD_WANDB_API_KEY/export WANDB_API_KEY=$NEW_WANDB_API_KEY/" ~/.bashrc || echo "export WANDB_API_KEY=$NEW_WANDB_API_KEY" >> ~/.bashrc)
echo "now type source ~/.bashrc"
python3 -m wandb login