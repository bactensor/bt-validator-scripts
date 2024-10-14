#!/bin/bash
git clone https://github.com/bettensor/bettensor.git  ~/.bittensor/subnets/bettensor/
cd ~/.bittensor/subnets/bettensor/ || exit

sudo apt-get update && sudo apt-get install python3.10-venv

python3.10 -m venv ~/venvs/bettensor
source ~/venvs/bettensor/bin/activate

if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

wandb login $WANDB_API_KEY

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

pm2 start --name validator python3 -- ./neurons/validator.py --netuid $BITTENSOR_NETUID \
    --subtensor.network local \
    --axon.port 54121 \
    --subtensor.chain_endpoint $BITTENSOR_SUBTENSOR_CHAIN_ENDPOINT \
    --wallet.hotkey $BITTENSOR_WALLET_HOTKEY_NAME \
    --wallet.name $BITTENSOR_WALLET_NAME \
    --logging.debug

