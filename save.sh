#!/bin/bash

# Files
cp ~/.config/fish/config.fish                  .config/fish/config.fish
cp ~/.config/fish/functions/fish_greeting.fish .config/fish/functions/fish_greeting.fish
cp ~/.config/kitty/kitty.conf                  .config/kitty/kitty.conf
cp ~/.xsessionrc                               .xsessionrc
cp ~/.bash_aliases                             .bash_aliases
cp ~/.config/nvim/init.lua                     .config/nvim/init.lua
cp ~/.config/Code/User/keybindings.json        .config/Code/User/keybindings.json
cp ~/.config/Code/User/settings.json           .config/Code/User/settings.json

# Directories
cp -rT ~/.fonts .fonts
