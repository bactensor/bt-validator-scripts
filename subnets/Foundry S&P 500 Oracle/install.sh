#!/bin/bash
git clone https://github.com/foundryservices/snpOracle.git 
cp .env snpOracle/.env
cp validator.config.js snpOracle/validator.config.js 


cd snpOracle
python3 -m venv venv
source venv/bin/activate


python3 -m pip install -r requirements.txt
python3 -m pip install -e .
