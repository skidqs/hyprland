alias clear='clear'
alias cls='clear && fastfetch'
fastfetch

function set_prompt {
    local MAX_PATH_LEN=30
    local DIR_PLAIN=$(pwd)

    if [[ "$DIR_PLAIN" == "$HOME" ]]; then
        DIR="~"
    else
        DIR="$DIR_PLAIN"
        if (( ${#DIR} > MAX_PATH_LEN )); then
            DIR="…${DIR: -$MAX_PATH_LEN}"
        fi
    fi

    local LEFT="\[\e[1m\][\u@\h ${DIR}]\$ \[\e[0m\]"

    local DATE_TIME="\[\e[1m\]$(date +'%I:%M %p %d/%m/%Y' | tr '[:lower:]' '[:upper:]')\[\e[0m\]"

    local LEFT_VISIBLE="[${USER}@${HOSTNAME} ${DIR}]\$ "
    local RIGHT_VISIBLE="$(date +'%I:%M %p %d/%m/%Y' | tr '[:lower:]' '[:upper:]')"
    local COLUMNS=$(tput cols)
    local PADDING=$(( COLUMNS - ${#LEFT_VISIBLE} - ${#RIGHT_VISIBLE} ))
    if (( PADDING < 1 )); then PADDING=1; fi

    PS1="${LEFT}\[\e[s\]\[\e[${PADDING}C\]${DATE_TIME}\[\e[u\]"
}

PROMPT_COMMAND=set_prompt
