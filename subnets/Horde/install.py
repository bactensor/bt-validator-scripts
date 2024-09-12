import argparse
import os
import secrets
import logging
import time
from fabric import Connection
from invoke import Responder
import yaml
from dotenv import load_dotenv
import paramiko
from paramiko import SSHClient

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def load_config(config_file='config.yaml'):
    """Loads the configuration from a YAML file."""
    try:
        with open(config_file, 'r') as file:
            return yaml.safe_load(file)
    except FileNotFoundError:
        logging.error(f"Configuration file {config_file} not found.")
        raise
    except yaml.YAMLError as exc:
        logging.error(f"Error parsing YAML file: {exc}")
        raise RuntimeError(f"Error parsing YAML file: {exc}")

def create_remote_directory(hostname, username, password, remote_directory_path, port=22):
    """Creates a directory on the remote server."""
    connection = Connection(host=hostname, user=username, connect_kwargs={'password': password})
    try:
        connection.run(f'mkdir -p {remote_directory_path}')
        print(f"Directory structure '{remote_directory_path}' created or already exists.")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        connection.close()

def get_subnet_config(subnet_codename, mainnet_number, testnet_number, developer_id, config):
    """Retrieves the subnet configuration based on parameters."""
    for subnet in config['subnets']:
        if (subnet['codename'] == subnet_codename and
            subnet['mainnet_number'] == mainnet_number and
            subnet['testnet_number'] == testnet_number and
            developer_id in subnet['developer_ids']):
            return subnet
    return None

def prepare_env_variables(subnet_config):
    """Prepares environment variables based on the subnet configuration."""
    allowed_secrets = subnet_config['allowed_secrets']
    env_variables = {key: os.getenv(key) for key in allowed_secrets if os.getenv(key) is not None}
    return env_variables

def write_env_file(env_variables, directory):
    """Writes environment variables to a .env file in the specified directory."""
    if not os.path.exists(directory):
        os.makedirs(directory)
    filename = os.path.join(directory, '.env')
    try:
        with open(filename, 'w') as file:
            for key, value in env_variables.items():
                file.write(f"{key}={value}\n")
    except OSError as e:
        logging.error(f"Error writing .env file: {e}")
        raise

def find_secret(subnet_codename, mainnet_number, testnet_number, developer_id):
    """Loads configuration, prepares environment variables, and retrieves secrets."""
    load_dotenv()
    config = load_config()
    subnet_config = get_subnet_config(subnet_codename, mainnet_number, testnet_number, developer_id, config)
    if not subnet_config:
        logging.error("Subnet configuration not found.")
        raise ValueError("Subnet configuration not found.")
    env_variables = prepare_env_variables(subnet_config)
    return env_variables

def create_connection(hostname, username, password):
    """Creates a connection to the remote server."""
    return Connection(
        host=hostname,
        user=username,
        connect_kwargs={"password": password}
    )

def execute_remote_command(connection, commands):
    """Executes commands on the remote server."""
    if isinstance(commands, list):
        command = " && ".join(commands)
    else:
        command = commands
    result = connection.run(command, hide=False)
    print(result.stdout)
    print(result.stderr)
    return result.stdout, result.stderr

def main():
    """Main function to handle argument parsing and remote deployment."""
    parser = argparse.ArgumentParser(description="Install validator script")
    parser.add_argument("ssh_destination", help="SSH destination")
    parser.add_argument("password", help="Remote server password")
    parser.add_argument("hotkey_path", help="Path to the hotkey file")
    args = parser.parse_args()

    ssh_destination = args.ssh_destination
    local_hotkey_path = os.path.realpath(args.hotkey_path)
    password = args.password
    local_coldkey_pub_path = os.path.join(os.path.dirname(os.path.dirname(local_hotkey_path)), 'coldkeypub.txt')

    if not os.path.isfile(local_hotkey_path):
        raise FileNotFoundError("Given HOTKEY_PATH does not exist")

    hotkey_name = os.path.basename(local_hotkey_path)
    wallet_name = os.path.basename(os.path.dirname(os.path.dirname(local_hotkey_path)))

    if any(c in hotkey_name for c in '$#!;*?&()<>\"\''):
        hotkey_name = 'default'
    if any(c in wallet_name for c in '$#!;*?&()<>\"\''):
        wallet_name = 'mywallet'

    remote_hotkey_path = f".bittensor/wallets/{wallet_name}/hotkeys/{hotkey_name}"
    remote_coldkey_pub_path = f".bittensor/wallets/{wallet_name}/coldkeypub.txt"
    REMOTE_HOTKEY_DIR = os.path.dirname(remote_hotkey_path)
    REMOTE_HOTKEY_DIR = '~/' + REMOTE_HOTKEY_DIR
    username, hostname = ssh_destination.split('@')

    connection = create_connection(hostname, username, password)

    remote_directory = '~/compute_horde'
    create_remote_directory(hostname, username, password, remote_directory)
    create_remote_directory(hostname, username, password, REMOTE_HOTKEY_DIR)
    time.sleep(3)
    sec = find_secret("compute-horde", 12, 174, 'dev123')

    local_env_file = "subnets/Horde/.env"
    with open(local_env_file, 'w') as env_file:
        env_file.write(f"DEBUG_WEIGHTS_VERSION=1\n")
        env_file.write(f"SECRET_KEY={secrets.token_urlsafe(25)}\n")
        env_file.write(f"POSTGRES_PASSWORD={secrets.token_urlsafe(16)}\n")
        env_file.write(f"BITTENSOR_NETUID=12\n")
        env_file.write(f"BITTENSOR_NETWORK=finney\n")
        env_file.write(f"BITTENSOR_WALLET_NAME={wallet_name}\n")
        env_file.write(f"BITTENSOR_WALLET_HOTKEY_NAME={hotkey_name}\n")
        env_file.write(f"HOST_WALLET_DIR=$HOME/.bittensor/wallets\n")
        env_file.write(f"COMPOSE_PROJECT_NAME=compute_horde_validator\n")
        env_file.write(f"FACILITATOR_URI=wss://facilitator.computehorde.io/ws/v0/\n")
    with open(local_env_file, 'a') as file:
        for key, value in sec.items():
            file.write(f"{key}={value}\n")
    print(".env file created successfully.")

    docker_compose_content = """
version: '3.7'
services:
  validator-runner:
    image: backenddevelopersltd/compute-horde-validator-runner:v0-latest
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - "$HOME/.bittensor/wallets:/root/.bittensor/wallets"
      - ./.env:/root/validator/.env
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
  watchtower:
    image: containrrr/watchtower:latest
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: --interval 60 --cleanup --label-enable
    """

    with open('subnets/Horde/docker-compose.yml', 'w') as docker_compose_file:
        docker_compose_file.write(docker_compose_content)

    connection.put(local_hotkey_path, remote=remote_hotkey_path)
    connection.put(local_coldkey_pub_path, remote=remote_coldkey_pub_path)
    connection.put(local_env_file, remote='compute_horde/.env')
    connection.put('subnets/Horde/docker-compose.yml', remote='compute_horde/docker-compose.yml')
    connection.put('subnets/Horde/install.sh', remote='compute_horde/install.sh')
    connection.put('subnets/Horde/run_vali.sh', remote='compute_horde/run_vali.sh')

    time.sleep(5)

    docker_commands = [
        "set -euxo pipefail",
        "cd compute_horde",
        'ls',
        f"echo '{password}' | sudo -S chmod +x install.sh",
        f"echo '{password}' | sudo -S ./install.sh",
    ]
    execute_remote_command(connection, docker_commands)

if __name__ == "__main__":
    main()



# python3 install.py shane@37.27.180.98 "your server password" /Users/mac/Downloads/project/wallet/wombo/hotkeys/JJa

