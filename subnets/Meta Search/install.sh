#!/bin/bash
git clone https://github.com/surcyf123/smart-scrape.git
cp .env smart-scrape/.env

cd smart-scrape
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -r requirements.txt
python3 -m pip install -e .
