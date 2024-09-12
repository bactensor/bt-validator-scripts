#!/bin/bash

git clone https://github.com/It-s-AI/llm-detection  
cp .env llm-detection/.env

cd llm-detection
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -e .

sudo apt update
sudo apt install lshw -y

sudo python3 -m pip install mathgenerator

curl -fsSL https://ollama.com/install.sh | sh

sudo nohup ollama serve

ollama pull vicuna

ollama pull mistral

ollama pull zephyr:7b-beta

ollama pull neural-chat

ollama pull gemma:7b