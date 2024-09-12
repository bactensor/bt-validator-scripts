#!/bin/bash
#no gpu


git clone https://github.com/GraphiteAI/Graphite-Subnet.git 

cd Graphite-Subnet

sudo apt install python3.10-venv

python3.10 -m venv venv-sn43-graphite

source venv-sn43-graphite/bin/activate

export PIP_NO_CACHE_DIR=1

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

