#!/bin/bash
#NO GPU 
git clone https://github.com/macrocosm-os/folding.git
sleep 10
cp .env folding/.env

cd folding
python3 -m venv venv
source venv/bin/activate

apt install nvidia-cuda-toolkit

echo "check output of installer, may need to install nvidia-cuda-toolkit properly"
echo "also do venv"
sleep 5

echo "now run bash install.sh"

echo "The above commands will install the necessary requirements, as well as download GROMACS and add it to your .bashrc. To ensure that installation is complete, running gmx in the terminal should print: :-) GROMACS - gmx, 2023.1-Ubuntu_2023.1_2ubuntu1 (-:"

echo "now run bash install.sh"