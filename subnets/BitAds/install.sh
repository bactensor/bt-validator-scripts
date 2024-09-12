#!/bin/bash
git clone https://github.com/eseckft/BitAds.ai.git 
cp .env BitAds.ai/.env

cd BitAds.ai
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -e .
python3 setup.py install_lib
python3 setup.py build