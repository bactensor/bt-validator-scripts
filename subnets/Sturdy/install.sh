#!/bin/bash
#NO GPU YET
git clone https://github.com/Sturdy-subnet/sturdy-subnet/ 
cp .env sturdy-subnet/.env

cd sturdy-subnet
python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
python3 -m pip install -e .

