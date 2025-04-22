## Instructions

- Install ubuntu ISO
- Run:
    ```
    sudo apt update && sudo apt upgrade -y && sudo apt install git
    reboot
    ```
- Install GPU drivers if needed
- Reboot with secure boot password if needed
- Install config and apps:
    ```
    git clone https://github.com/ramenguy99/config
    cd config
    ./ubuntu-24.04.sh
    ```
- Reboot and enter DWM
- Setup pam delay and sudo if needed (see `notes/`)

