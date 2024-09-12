#!/bin/bash
#needs GPU 20GB

git clone https://github.com/RaoFoundation/pretraining.git

cp .env pretraining/.env
cd pretraining
python3 -m venv venv
source venv/bin/activate

python3 -m pip install packaging
python3 -m pip install wheel
python3 -m pip install torch

python3 -m pip install -r requirements.txt
python3 -m pip install -e .
