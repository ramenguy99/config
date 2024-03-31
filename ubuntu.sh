#!/bin/bash

# TODO:
#
# dwmbar:
# - gpu usage
# - printf style justify to have it not move around

# Adjust delay before repeating a keypress
gsettings set org.gnome.desktop.peripherals.keyboard delay 275
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 33

# Add neovim repo
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update

# Install packages
sudo apt install -y \
    neovim \
    fish \
    kitty \
    fd-find \
    ripgrep \
    build-essentials \
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
    arandr    

# Change default shell to fish
chsh -s /usr/bin/fish

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

    # Download rust-analyzer
    rustup component add rust-analyzer
fi

# Install eza
if ! command -v eza &> /dev/null
then
    cargo install eza
fi

# Refresh fonts
fc-cache -fv

# Install custom libXft to avoid dwm crash
sudo apt install -y xutils-dev
git clone https://github.com/uditkarode/libxft-bgra
cd libxft-bgra
git checkout 072cd202c0f4f757b32deac531586bc0429c8401
sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
sudo make install
sudo ln -sf /usr/lib/libXft.so.2.3.3 /lib/x86_64-linux-gnu/libXft.so.2
rm -rf libxft-bgra
cd ..

# Build dwm
if ! command -v dwm &> /dev/null
then
    sudo apt build-dep -y dwm
    cd dwm
    make -j
    sudo make install PREFIX=/usr
    cd ..
    sudo cp dwm.desktop /usr/share/xsessions
fi

# If a battery is detected install TLP for power management
if [ -d /sys/class/power_supply/BAT? ]:
then
    sudo apt install -y tlp
    sudo systemctl enable tlp.service
    # -> manually edit /etc/tlp.conf based on your laptop and restart service
fi

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/vi
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/vim
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/bin/nvim

# Install vscode
if ! command -v code &> /dev/null
then
    wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' code.deb
    sudo apt install ./code.deb
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-vscode.cpptools
    code --install-extension rust-lang.rust-analyzer
    code --install-extension twxs.cmake
    code --install-extension vscodevim.vim
fi

# Add aliases
fish aliases.fish

# Files
cp .config/fish/config.fish                  ~/.config/fish/config.fish
cp .config/fish/functions/fish_greeting.fish ~/.config/fish/functions/fish_greeting.fish
cp .config/kitty/kitty.conf                  ~/.config/kitty/kitty.conf
cp .xsessionrc                               ~/.xsessionrc
cp .bash_aliases                             ~/.bash_aliases
cp .config/nvim/init.lua                     ~/.config/nvim/init.lua
cp .config/Code/User/keybindings.json        ~/.config/Code/User/keybindings.json
cp .config/Code/User/settings.json           ~/.config/Code/User/settings.json

# Directories
cp -r .fonts ~/.fonts
