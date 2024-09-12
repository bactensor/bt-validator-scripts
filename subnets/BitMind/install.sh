#!/bin/bash


git clone https://github.com/bitmind-ai/bitmind-subnet 
cp .env bitmind-subnet/.env

cd bitmind-subnet

sudo chmod +x install_system_deps.sh
./install_system_deps.sh

python3 bitmind/download_data.py

sudo apt install python3.10-venv

python3.10 -m venv venv-sn34-bitmind_venv

source venv-sn34-bitmind_venv/bin/activate

export PIP_NO_CACHE_DIR=1

python3 -m pip install -e .

