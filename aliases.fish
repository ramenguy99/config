#!/bin/fish

alias --save duh="du -hs .[^.]* * | sort -h"
alias --save dfm="df -hT -x tmpfs -x efivarfs"
alias --save fd="fdfind"
alias --save xclip="xclip -sel clip"
alias --save ls="eza"
alias --save ll="eza -lah"
alias --save lsg="eza -l --git --header --git-repos"
