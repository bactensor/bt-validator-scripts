#!/bin/bash


git clone https://github.com/xzistance/sportstensor/
cp .env sportstensor/.env

cd sportstensor
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -e .

