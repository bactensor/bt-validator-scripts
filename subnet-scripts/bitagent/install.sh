#!/bin/bash -eu

git clone https://github.com/RogueTensor/bitqna_subnet ~/.bittensor/subnets/bitqna_subnet/

cd ~/.bittensor/subnets/bitqna_subnet/

python3 -m venv venv
python3 -m pip install -r requirements.txt
python3 -m pip install -e .
python3 -m pip uninstall uvloop

sudo service docker start

export $(awk '!/^#/ && /=/ {print}' .env)

pm2 start run.sh --name bitagent_validators_autoupdate -- \
    --wallet.name "$BITTENSOR_WALLET_NAME" \
    --wallet.hotkey "$BITTENSOR_WALLET_HOTKEY_NAME" \
    --netuid "$BITTENSOR_NETUID" \
    --logging.debug \
    --subtensor.chain_endpoint "$BITTENSOR_SUBTENSOR_CHAIN_ENDPOINT" \
    --axon.port 8105 \
    --neuron.sample_size 60 \
    --axon.ip 123.123.123.123 \
    --neuron.device cpu
