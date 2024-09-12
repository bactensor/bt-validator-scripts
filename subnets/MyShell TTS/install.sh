#!/bin/bash
git clone https://github.com/myshell-ai/MyShell-TTS-Subnet 
cp .env MyShell-TTS-Subnet/.env

cd MyShell-TTS-Subnet
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -e .
python3 -m unidic download
sudo apt-get install ffmpeg
apt-get install ffmpeg
export TOKENIZERS_PARALLELISM=true
source ~/.bashrc
echo "do source ~/bashrc for export TOKENIZERS_PARALLELISM=true, or check it"