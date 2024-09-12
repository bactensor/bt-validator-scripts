#!/bin/bash
#no gpu
git clone https://github.com/score-protocol/score-predict.git 
cp .env score-predict/.env

cd score-predict

sudo apt install python3.10-venv -y

python3.10 -m venv venv-sn44-score-predict

source venv-sn44-score-predict/bin/activate

python3 -m pip install -r requirements.txt

git clone https://github.com/opentensor/bittensor.git

cd bittensor
git checkout release/7.2.1
python3 -m pip install -e .

export PYTHONPATH="~/.bittensor/subnets/score-predict:$PYTHONPATH"

