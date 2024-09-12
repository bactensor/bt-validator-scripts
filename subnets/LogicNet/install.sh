#!/bin/bash
git clone https://github.com/LogicNet-Subnet/LogicNet 
cp .env LogicNet/.env

cd LogicNet
python3 -m venv venv
source venv/bin/activate

echo "screenshot:"
echo "python3 -m venv venv-main-sn35-logicnet"
echo ". vevenv-main-sn35-logicnet/bin/activate"
echo "sleeping for 15..."
sleep 15

pip install -e .
pip uninstall uvloop -y
pip install git+https://github.com/lukew3/mathgenerator.git

