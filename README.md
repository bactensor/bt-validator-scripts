# Automatic Validator Installation Platform

## Description

This project is a platform designed to automate the installation of validators across multiple subnets. It leverages a common `.env` file containing all sensitive information for individual validators, such as API keys, and utilizes a configuration file to manage access controls for each subnet.

## Features

- **Automated Installation**: Simplifies the validator installation process across various subnets.
- **Access Control**: Uses a configuration file to control which secrets each subnet can access.
- **Dynamic Environment Files**: Generates subnet-specific `.env` files containing only the allowed secrets.

## Project Structure

- **Common `.env` File**: Contains sensitive information like `OPENAI_API_KEY`, `WANDB_API_KEY`, etc.
- **Configuration File (`config.yaml`)**: 
  - Defines each subnet's name, `mainnet_number`, `testnet_number`, `developer_ids`, and `allowed_secrets`.
  - Example entry:
    ```yaml
    - codename: "cortex.t"
      mainnet_number: 18
      testnet_number: 24
      developer_ids: ["dev24"]
      allowed_secrets: ["OPENAI_API_KEY_18", "ANTHROPIC_API_KEY"]
    ```

## Installation

### Prerequisites

- Python 3.10
- pip
- npm
- Other dependencies as specified in `requirements.txt`

### Example script for install and run subnet validator

1. **Clone the Repository**

   ```bash
   git clone https://github.com/RogueTensor/bitagent_subnet.git
   cd bitagent_subnet
   ```

2. **Set Up Virtual Environment**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install Python Dependencies**

   ```bash
   python3 -m pip install -r requirements.txt
   python3 -m pip install -e .
   ```

4. **Install System Dependencies**

   ```bash
   sudo apt update
   sudo apt install jq
   sudo apt install npm
   sudo npm install pm2 -g
   pm2 update
   ```

5. **Run validator**

   ```bash
   pm2 start run.sh --name bitagent_validators -- --wallet.name $WALLET_NAME --wallet.hotkey $WALLET_HOTKEY_NAME --netuid 20 --logging.debug \
   --subtensor.chain_endpoint ws://REDACTED:9944 --axon.port 8105 --neuron.sample_size 60 --axon.ip 123.123.123.123 --neuron.device cpu
   
   pm2 log
   ```


## Usage

1. **Configure Subnet Access**: Modify `config.yaml` to specify which secrets each subnet can access.
2. **Run Installation Script**: Use the provided scripts to generate subnet-specific `.env` files and perform installations.

   ```bash
   python manage.py
    Enter the SSH destination: (ex : shane@38.29.180.99)
    shane@38.29.180.99     
    Enter your password:
    Enter the Local Hotkey Path:  (ex : /Users/mac/Downloads/project/wallet/wombo/hotkeys/JJa)
    /Users/mac/Downloads/project/wallet/wombo/hotkeys/JJa
   ```

## Configuration

- **Common `.env` File**: Store all sensitive information here.
- **Subnet-Specific `.env` Files**: Automatically generated based on the `config.yaml` file.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss changes.

## License



## Contact

 please contact cs.eros111@gmail.com