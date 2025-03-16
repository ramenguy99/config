#!/bin/bash -ex

# TODO:
#
# dwmbar:
# - show main internet connection? e.g. something from nmcli?
# - fix wifi to not show anything when not connected, use nmcli?
# - gpu usage (need gpu detection / portable solution / fallback to none)

# Adjust delay before repeating a keypress
gsettings set org.gnome.desktop.peripherals.keyboard delay 275
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 33

# Install packages
sudo apt install -y \
    kitty \
    fd-find \
    ripgrep \
    build-essential \
    git \
    autojump \
    xclip \
    curl \
    cmake \
    ninja-build \
    htop \
    btop \
    python-is-python3 \
    suckless-tools \
    arandr \
    libx11-dev \
    libxinerama-dev \
    libxft-dev \
    picom

# Config git
git config --global user.email "dmylos@yahoo.it"
git config --global user.name "Dario Mylonopoulos"
git config --global init.defaultBranch "main"

# Change default terminal emulator to kitty
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

# Install rust
if ! command -v rustup &> /dev/null
then
    # Download rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    
    source ~/.cargo/env

    # Download rust-analyzer
    rustup component add rust-analyzer
fi

# Install eza
if ! command -v eza &> /dev/null
then
    cargo install eza
fi

# Install clipmenu
if ! command -v clipmenu &> /dev/null
then
    cd clipmenu
    make -j
    sudo make install
fi

# Build dwm
if ! command -v dwm &> /dev/null
then
    cd dwm
    make -j
    sudo make install PREFIX=/usr
    cd ..
    sudo cp dwm.desktop /usr/share/xsessions
fi

# Install dwmbar
if ! command -v dwmbar &> /dev/null
then
    cd dwmbar
    sudo ./install.sh
    cd ..
fi

# If a battery is detected install TLP for power management
if [ -d /sys/class/power_supply/BAT? ]:
then
    sudo apt install -y tlp
    sudo systemctl enable tlp.service
    # -> manually edit /etc/tlp.conf based on your laptop and restart service
fi

# Install neovim
if ! command -v nvim &> /dev/null
then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/vi
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/vim
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim
fi

# Install miniconda
if ! command -v conda &> /dev/null
then
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    ~/miniconda3/bin/conda init bash
fi

# Install vscode
if ! command -v code &> /dev/null
then
    wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O code.deb
    sudo apt install ./code.deb
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-vscode.cpptools
    code --install-extension rust-lang.rust-analyzer
    code --install-extension twxs.cmake
    code --install-extension vscodevim.vim
fi


# Files
mkdir -p ~/.config/kitty
mkdir -p ~/.config/nvim
mkdir -p ~/.config/Code/User
cp .config/kitty/kitty.conf                  ~/.config/kitty/kitty.conf
cp .xsessionrc                               ~/.xsessionrc
cp .bash_aliases                             ~/.bash_aliases
cp .config/nvim/init.lua                     ~/.config/nvim/init.lua
cp .config/Code/User/keybindings.json        ~/.config/Code/User/keybindings.json
cp .config/Code/User/settings.json           ~/.config/Code/User/settings.json

# Directories
cp -r .fonts ~/.fonts

# Refresh fonts
fc-cache -fv

# Configure bash history
sed -i s/HISTSIZE=.\*/HISTSIZE=100000/ ~/.bashrc
sed -i s/HISTFILESIZE=.\*/HISTFILESIZE=100000/ ~/.bashrc

# Add CM_DIR to bashrc
grep -q CM_DIR ~/.bashrc || (echo >> ~/.bashrc && echo 'export CM_DIR=$HOME/.clipmenu' >> ~/.bashrc)