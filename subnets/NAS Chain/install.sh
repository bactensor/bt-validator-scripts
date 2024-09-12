#!/bin/bash
git clone https://github.com/neuronlogic/NASChain 
cp .env NASChain/.env

cd NASChain
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
pip install -e .

