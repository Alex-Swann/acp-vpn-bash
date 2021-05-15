#!/bin/bash

export PATH=$(brew --prefix openvpn)/sbin:$PATH

PROFILES=( kube-platform acp-prod jira-confluence )
PROFILES_LABELS=( 'Kube Platform' 'ACP Prod' 'JIRA' )

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function prompt_for_multiselect {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      if [[ ${arr[option]} == true ]]; then
        arr[option]=
      else
        arr[option]=true
      fi
      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options
    local defaults

    IFS=';' read -r -a options <<< "$2"
    if [[ -z $3 ]]; then
      defaults=()
    else
      IFS=';' read -r -a defaults <<< "$3"
    fi
    local selected=()

    for ((i=0; i<${#options[@]}; i++)); do
      selected+=("${defaults[i]}")
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ ${selected[idx]} == true ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}

function selected_values {
  if [ "$1" != 'all' ]; then
    prompt_for_multiselect SELECTED "$OPTIONS_STRING"

    for i in "${!SELECTED[@]}"; do
      if [ "${SELECTED[$i]}" == "true" ]; then
        USE_PROFILES+=("${PROFILES[$i]}")
      fi
    done
  else
    USE_PROFILES=( "${PROFILES[@]}" )
  fi
}

function startup_vpns {
  for profile in "${USE_PROFILES[@]}"; do
    sudo kill $(ps -ax | grep -i $profile | head -1 | awk '{print $1}')
    for FILE in `find "$HOME/Downloads" -name "vpn-$profile*.ovpn" -type f | sort | tail -1`; do
      openvpn --config $FILE &
    done
  done
  echo "VPNs started!"
}

function shutdown_vpns {
  for profile in "${USE_PROFILES[@]}"; do
    sudo kill $(ps -ax | grep -i $profile | head -1 | awk '{print $1}')
  done
  echo "Shutting down VPNs!"
}

function refresh_vpn_profiles {
  find "/Users/$USER/Downloads" -mtime +2 -name "vpn-*.ovpn" -type f -delete

  for profile in "${USE_PROFILES[@]}"; do
    /usr/bin/open -a "/Applications/Google Chrome.app" "https://access-acp.digital.homeoffice.gov.uk/ui/profiles/$profile/issue?template=Default"
    sleep 1
  done
}

function watch_vpns {
  watch --color "ps -ax | GREP_COLOR='1;32' grep --color=always -i '[o]penvpn --config'"
}

function list_vpns {
  ps -ax | GREP_COLOR='1;32' grep --color=always -i '[o]penvpn --config'
}

for i in "${!PROFILES[@]}"; do
	OPTIONS_STRING+="${PROFILES[$i]} (${PROFILES_LABELS[$i]});"
done

if [ "$1" == 'refresh' ]; then
  selected_values $2
  refresh_vpn_profiles
fi

if [ "$1" == 'start' ]; then
  selected_values $2
  startup_vpns
fi

if [ "$1" == 'stop' ]; then
  selected_values $2
  shutdown_vpns
fi

if [ "$1" == 'watch' ]; then
  watch_vpns
fi

if [ "$1" == 'list' ]; then
  list_vpns
fi
