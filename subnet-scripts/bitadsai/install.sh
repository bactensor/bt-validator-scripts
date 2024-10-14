#!/bin/bash
git clone https://github.com/eseckft/BitAds.ai.git ~/.bittensor/subnets/BitAds.ai/

cd ~/.bittensor/subnets/BitAds.ai/
# requires python3.11
sudo apt-get update && sudo apt-get install python3.11 python3.11-venv
python3.11 -m venv venv
source venv/bin/activate

python3.11 -m pip install -e .
python3.11 setup.py install_lib
python3.11 setup.py build

wget https://git.io/GeoLite2-Country.mmdb

python3.11 -m pip install --upgrade pip
python3.11 pip install -r requirements.txt

apt-get update
apt-get install sqlite3

if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

pm2 start run_validator_auto_update.py \
    --log-date-format "HH:mm:ss.SSS MM-DD-YY Z" \
    --time --restart-delay 15000 \
    --interpreter python3 -- \
    --netuid $BITTENSOR_NETUID \
    --wallet.name $BITTENSOR_WALLET_NAME \
    --wallet.hotkey $BITTENSOR_WALLET_HOTKEY_NAME \
    --subtensor.chain_endpoint $BITTENSOR_SUBTENSOR_CHAIN_ENDPOINT \
    --logging.debug \
    --logging.trace \
    --axon.port 26842
