#!/bin/bash

git clone https://github.com/OpenKaito/openkaito.git 
sleep 10
cp .env openkaito/.env
cd openkaito
python3 -m venv venv
source venv/bin/activate
python3 -m pip install -r requirements.txt
python3 -m pip install -e .

