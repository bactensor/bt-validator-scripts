#!/bin/bash
#NO GPU 

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs

sudo apt-get install net-tools

git clone https://github.com/impel-intelligence/dippy-bittensor-subnet.git 
cp .env dippy-bittensor-subnet/.env

cd dippy-bittensor-subnet
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -e .
