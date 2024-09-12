#!/bin/bash
git clone https://github.com/BitAPAI/cortex.t.git 
cp .env cortex.t/.env

cd cortex.t
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -r requirements.txt
python3 -m pip install -e .