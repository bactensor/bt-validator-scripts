#!/bin/bash

git clone https://github.com/omegalabsinc/omegalabs-bittensor-subnet.git  
cp .env omegalabs-bittensor-subnet/.env

cd omegalabs-bittensor-subnet
python3 -m venv venv
source venv/bin/activate

apt-get -y update && apt-get install -y ffmpeg


python3 -m pip install -r requirements.txt
python3 -m pip install -e .
