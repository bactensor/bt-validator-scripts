import argparse
import logging
import time
from fabric import Connection

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

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
    args = parser.parse_args()

    ssh_destination = args.ssh_destination
    password = args.password
    username, hostname = ssh_destination.split('@')

    connection = create_connection(hostname, username, password)

    time.sleep(5)

    docker_commands = [
        "set -euxo pipefail",
        "cd finetuning",
        f"echo '{password}' | sudo -S chmod +x run_vali.sh",
        f"echo '{password}' | sudo -S ./run_vali.sh",
    ]
    execute_remote_command(connection, docker_commands)

if __name__ == "__main__":
    main()



# python3 run_vali.py shane@37.27.180.98 "Type your password"

