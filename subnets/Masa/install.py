import argparse
import os
import secrets
from fabric import Connection
from invoke import Responder
import yaml
import os
import logging
from dotenv import load_dotenv
import argparse
import paramiko
from paramiko import SSHClient
import time
import secrets
import json

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
def load_config(config_file='config.yaml'):
    """
    Load the configuration from a YAML file.

    Args:
        config_file (str): Path to the configuration file.

    Returns:
        dict: Parsed configuration data.

    Raises:
        FileNotFoundError: If the configuration file is not found.
        RuntimeError: If there is an error parsing the YAML file.
    """
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
    connection = Connection(host=hostname, user=username, connect_kwargs={'password': password})
    # Create an SSH client
    try:
        # Use 'mkdir -p' to create the directory structure
        # The '-p' flag ensures that all necessary parent directories are created
        # and that no error is raised if the directory already exists.
        connection.run(f'mkdir -p {remote_directory_path}')
        print(f"Directory structure '{remote_directory_path}' created or already exists.")
    except Exception as e:
        # Handle exceptions that may occur during the directory creation
        print(f"An error occurred: {e}")
    finally:
        # Close the connection to ensure resources are freed
        connection.close()

def get_subnet_config(subnet_codename, mainnet_number, testnet_number, developer_id, config):
    """
    Retrieve the subnet configuration based on the provided parameters.

    Args:
        subnet_codename (str): Codename of the subnet.
        mainnet_number (str): Mainnet number of the subnet.
        testnet_number (str): Testnet number of the subnet.
        developer_id (str): Developer ID.
        config (dict): Configuration data.

    Returns:
        dict or None: Subnet configuration if found, otherwise None.
    """
    for subnet in config['subnets']:
        if (subnet['codename'] == subnet_codename and
            subnet['mainnet_number'] == mainnet_number and
            subnet['testnet_number'] == testnet_number and
            developer_id in subnet['developer_ids']):
            return subnet
    return None

def prepare_env_variables(subnet_config):
    """
    Prepare environment variables based on the subnet configuration.

    Args:
        subnet_config (dict): Subnet configuration data.

    Returns:
        dict: Environment variables.
    """
    allowed_secrets = subnet_config['allowed_secrets']
    env_variables = {key: os.getenv(key) for key in allowed_secrets if os.getenv(key) is not None}
    return env_variables

def find_secret(subnet_codename, mainnet_number, testnet_number, developer_id):
    """
    Main function to load configuration, prepare environment variables, and run the installation script.
    """
    load_dotenv()  # Load global secrets from .env file
    config = load_config()
    subnet_config = get_subnet_config(subnet_codename, mainnet_number, testnet_number, developer_id, config)
    
    if not subnet_config:
        logging.error("Subnet configuration not found.")
        raise ValueError("Subnet configuration not found.")

    env_variables = prepare_env_variables(subnet_config)
    return env_variables

def create_connection(hostname, username, password):
    return Connection(
        host=hostname,
        user=username,
        connect_kwargs={
            "password": password,
        }
    )

def execute_remote_command(connection, commands):
    if isinstance(commands, list):
        # Join the commands into a single string with '&&' to execute them sequentially
        command = " && ".join(commands)
    else:
        command = commands  # If it's already a string, use it as is

    # Run the command without hiding the output
    result = connection.run(command, hide=False)

    # Print the standard output and standard error to the local console
    print(result.stdout)
    print(result.stderr)

    return result.stdout, result.stderr

def main():
    parser = argparse.ArgumentParser(description="Install validator script")
    parser.add_argument("ssh_destination", help="SSH destination")
    parser.add_argument("password", help = "remote server password")
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

    # Set default names if they contain special characters
    if any(c in hotkey_name for c in '$#!;*?&()<>\"\''):
        hotkey_name = 'default'
    if any(c in wallet_name for c in '$#!;*?&()<>\"\''):
        wallet_name = 'mywallet'

    remote_hotkey_path = f".bittensor/wallets/{wallet_name}/hotkeys/{hotkey_name}"
    remote_coldkey_pub_path = f".bittensor/wallets/{wallet_name}/coldkeypub.txt"
    REMOTE_HOTKEY_DIR = os.path.dirname(remote_hotkey_path)
    REMOTE_HOTKEY_DIR = '~/' + REMOTE_HOTKEY_DIR
    username, hostname = ssh_destination.split('@')

    # Create connection
    connection = create_connection(hostname, username, password)

    remote_directory = '~/masa'
    create_remote_directory(hostname, username, password, remote_directory)
    create_remote_directory(hostname, username, password, REMOTE_HOTKEY_DIR)
    time.sleep(3)
    # sec = find_secret("masa", 42, 165, 'dev165')
    
    # Create .env file locally
    local_env_file = "subnets/Masa/.env"
    with open(local_env_file, 'w') as env_file:
        env_file.write(f"WALLET_NAME={wallet_name}\n")
        env_file.write(f"WALLET_HOTKEY_NAME={hotkey_name}\n")
        
    # with open(local_env_file, 'a') as file:
    #     for key, value in sec.items():
    #         file.write(f"{key}={value}\n")

    print(".env file created successfully.")
    
    # Use Fabric to copy files to the server
    connection.put(local_hotkey_path, remote=remote_hotkey_path)
    connection.put(local_coldkey_pub_path, remote=remote_coldkey_pub_path)
    connection.put(local_env_file, remote='masa/.env')
    connection.put('subnets/Masa/install.sh', remote='masa/install.sh')
    connection.put('subnets/Masa/run_vali.sh', remote='masa/run_vali.sh')
    # Execute commands to run Docker on the server
    time.sleep(5)
    
    docker_commands = [
        "set -euxo pipefail",
        "cd masa",
        f"echo '{password}' | sudo -S chmod +x install.sh",
        f"echo '{password}' | sudo -S ./install.sh",        
    ]
    execute_remote_command(connection, docker_commands)

    # Close the connection
    connection.close()

if __name__ == "__main__":
    main()

# python3 install.py shane@37.27.180.98 "your server password" /Users/mac/Downloads/project/wallet/wombo/hotkeys/JJa 




