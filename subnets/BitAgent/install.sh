#!/bin/bash
#does not need a GPU

#!/bin/bash

sudo apt update && sudo apt install jq && sudo apt install npm && sudo npm install pm2 -g && pm2 update

git clone https://github.com/RogueTensor/bitagent_subnet.git 
cp .env bitagent_subnet/.env

cd bitagent_subnet
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -r requirements.txt
python3 -m pip install -e .
#python -m pip uninstall uvloop
echo "add EXPORT_CUDA_VISIBLE_DEVICES='' and source ~/.bashrc otherwise it will try to use GPU but doens't need to"
echo "add EXPORT_CUDA_VISIBLE_DEVICES='' and source ~/.bashrc otherwise it will try to use GPU but doens't need to"
echo "add EXPORT_CUDA_VISIBLE_DEVICES='' and source ~/.bashrc otherwise it will try to use GPU but doens't need to"
echo "add EXPORT_CUDA_VISIBLE_DEVICES='' and source ~/.bashrc otherwise it will try to use GPU but doens't need to"
