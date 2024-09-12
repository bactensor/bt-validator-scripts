#!/bin/bash
#no gpu


git clone https://github.com/coldint/coldint_validator.git 
cp .env coldint_validator/.env
cp ecosystem.config.js coldint_validator/ecosystem.config.js

cd coldint_validator
sudo apt install python3.10-venv

python3.10 -m venv venv-sn29-coldint_venv

source venv-sn29-coldint_venv/bin/activate

python3 -m pip install packaging
python3 -m pip install wheel
python3 -m pip install torch

python3 -m pip install -r requirements.txt

python3 -m pip install -e .

