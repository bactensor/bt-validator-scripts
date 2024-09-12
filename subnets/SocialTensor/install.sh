#!/bin/bash
git clone https://github.com/NicheTensor/NicheImage.git
cp .env NicheImage/.env

cd NicheImage
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
pip install -e ~/NicheImage/
