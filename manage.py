import subprocess
import os
import getpass

def display_menu(options):
    print("Please select an option:")
    for number, description in options.items():
        print(f"{number}: {description}")

    return options

def get_user_choice(options):
    while True:
        try:
            choice = int(input("Enter the option number: "))
            if choice in options:
                return choice
            else:
                print("Invalid option. Please try again.")
        except ValueError:
            print("Please enter a valid number.")

def execute_script(directory, script_name, ssh_destination, password, local_hotkey_path):
    script_path = os.path.join('subnets', directory, script_name)
    try:
        if local_hotkey_path:
            subprocess.run(['python3', script_path, ssh_destination, password, local_hotkey_path], check=True)
        else:
            subprocess.run(['python3', script_path, ssh_destination, password], check=True)
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while executing {script_name}: {e}")

def main():
    first_options = {
        1: "Text Prompting",
        2: "Omron",
        3: "MyShell TTS",
        4: "Targon",
        5: "Open Kaito",
        6: "Infinite Games",
        7: "Subvortex",
        8: "Proprietary Trading Network",
        9: "Pretraining",
        10: "Sturdy",
        11: "Dippy Roleplay",
        12: "Horde",
        13: "Dataverse",
        14: "Palaidn",
        15: "De-Val",
        16: "BitAds",
        17: "Three Gen",
        18: "Cortex.t",
        19: "Vision",
        20: "BitAgent",
        21: "Omega Any-to-Any",
        22: "Meta Search",
        23: "SocialTensor",
        24: "Omega Labs",
        25: "Protein Folding",
        26: "Tensor Alchemy",
        27: "Compute",
        28: "Foundry S&P 500 Oracle",
        29: "Coldint",
        30: "Bettensor",
        31: "NAS Chain",
        32: "It's AI",
        33: "ReadyAI",
        34: "BitMind",
        35: "LogicNet",
        36: "Unknown",
        37: "Finetuning",
        38: "Unknown",
        39: "EdgeMaxxing",
        40: "Chunking",
        41: "Sportstensor",
        42: "Masa",
        43: "Graphite",
        44: "Score Predict",
        45: "Gen42",
    }

    second_options = {
        1: "Install validator",
        2: "Run validator",
    }

    while True:
        # Display the first set of options
        display_menu(first_options)
        subnet_choice = get_user_choice(first_options)
        selected_subnet = first_options[subnet_choice]
        print(f"You selected subnet option: {selected_subnet}")

        # Display the second set of options
        display_menu(second_options)
        intend_choice = get_user_choice(second_options)
        script_name = "install.py" if intend_choice == 1 else "run_vali.py"
        print(f"You selected intend option: {second_options[intend_choice]}")
        if script_name == 'install.py':
            # ssh_destination = input("Enter the SSH destination: (ex : shane@38.29.180.99)\n")
            ssh_destination = "shane@37.27.180.98"
            # password = getpass.getpass("Enter your password:")  # Secure password input
            password = "nowornever2024"
            # local_hotkey_path = input("Enter the local hotkey path:  (ex : /Users/mac/Downloads/Validator_installation_scripts/wallet/wombo/hotkeys/JJa)\n")
            local_hotkey_path = "/Users/mac/Downloads/Validator_installation_scripts/wallet/wombo/hotkeys/JJa"
            # Execute the selected script with parameters
            execute_script(selected_subnet, script_name, ssh_destination, password, local_hotkey_path)
        else:
            # ssh_destination = input("Enter the SSH destination: ")
            ssh_destination =  "shane@37.27.180.98"
            password = "nowornever2024"
            # password = getpass.getpass("Enter your password: ")  # Secure password input
            local_hotkey_path = None

            # Execute the selected script with parameters
            execute_script(selected_subnet, script_name, ssh_destination, password, local_hotkey_path)
        break

if __name__ == "__main__":
    main()
