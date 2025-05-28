# Color codes
RESET=$(echo -en '\001\033[0m\002')
RED=$(echo -en '\001\033[00;31m\002')
GREEN=$(echo -en '\001\033[00;32m\002')

# Function to capture pipestatus and format it
function format_pipestatus() {
  local status_list=("${PIPESTATUS[@]}")
  local status result=""
  for status in ${status_list[@]}; do
    if [[ $status -ne 0 ]]; then
      result+="${RED}${status}${RESET}|"
    else
      result+="${GREEN}${status}${RESET}|"
    fi
  done
  # Remove trailing '|'
  result="${result%|}"
  echo -n "[$result]"
}

# Precmd hook using PROMPT_COMMAND
function set_prompt() {
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $(format_pipestatus) \$ '
}

PROMPT_COMMAND=set_prompt

