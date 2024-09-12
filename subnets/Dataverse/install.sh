#!/bin/bash
git clone https://github.com/RusticLuftig/data-universe.git 
cp .env data-universe/.env

cd data-universe
python3 -m venv venv
source venv/bin/activate

python3 -m pip install -r requirements.txt
python3 -m pip install -e .

#sudo apt install mysql-server -y
#sudo systemctl start mysql.service
#sudo mysql <<MYSQL_SCRIPT
#CREATE DATABASE ValidatorStorage;
#CREATE USER 'data-universe-user'@'localhost' IDENTIFIED BY 'REDACTED';
#GRANT ALL PRIVILEGES ON ValidatorStorage.* TO 'data-universe-user'@'localhost';
#FLUSH PRIVILEGES;
#MYSQL_SCRIPT
