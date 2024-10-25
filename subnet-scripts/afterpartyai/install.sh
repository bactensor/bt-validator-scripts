#!/bin/bash -eu
#NO GPU 

git clone https://github.com/afterpartyai/bittensor-conversation-genome-project ~/.bittensor/subnets/cgp-subnet/

cd ~/.bittensor/subnets/cgp-subnet/

python3 -m pip install -r requirements.txt

export $(awk '!/^#/ && /=/ {print}' .env)

pm2 --time start python3 -- -m neurons.validator \
 --netuid "$BITTENSOR_NETUID" \
 --wallet.name "$BITTENSOR_WALLET_NAME" \
 --wallet.hotkey "$BITTENSOR_WALLET_HOTKEY_NAME" \
 --logging.debug \
 --logging.trace \
 --axon.port 17845 \
 --subtensor.chain_endpoint "$BITTENSOR_SUBTENSOR_CHAIN_ENDPOINT"
