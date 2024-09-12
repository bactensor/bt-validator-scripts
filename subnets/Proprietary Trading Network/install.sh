#!/bin/bash
#needs GPU 20GB
git clone https://github.com/taoshidev/time-series-prediction-subnet.git
sleep 10

cd time-series-prediction-subnet

python3 -m venv venv
source venv/bin/activate

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

python3 -m pip install twelvedata

cd ..

git clone https://github.com/taoshidev/proprietary-trading-network
sleep 10

cp .env proprietary-trading-network/.env
cp secrets.json proprietary-trading-network/secrets.json

cd proprietary-trading-network
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
python -m pip install -e .


