#!/bin/bash
#no GPU

sudo apt update

pm2 delete all

cd snpOracle
source venv/bin/activate

git fetch
git pull
pip install -e .

pm2 start validator.config.js

pm2 log


