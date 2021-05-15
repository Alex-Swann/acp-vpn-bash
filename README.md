# acp-vpn-bash
A bash script for managing ACP VPN profiles using OpenVPN

## Prerequisites
- brew install openvpn watch

## Run
This needs to be run in root user mode to ensure VPN profiles can be loaded
- `sudo ./acp_vpn.sh start all` - Starts all VPN Profiles listed in bash
- `sudo ./acp_vpn.sh start` - Opens up selection for user to choose which VPN to start from list in bash
- `sudo ./acp_vpn.sh stop all` - Stops all VPN Profiles listed in bash
- `sudo ./acp_vpn.sh stop` - Opens up selection for user to choose which VPN to stop from list in bash
- `sudo ./acp_vpn.sh refresh all` - Downloads all VPN Profiles listed in bash
- `sudo ./acp_vpn.sh refresh` - Opens up selection for user to choose which VPN to download from list in bash
- `sudo ./acp_vpn.sh list` - Lists all running OpenVPN processes on your machine
- `sudo ./acp_vpn.sh watch` - Watches all running OpenVPN processes on your machine

## Local
You can add the following to your `~/.bashrc` or `~/.bash_profile` to alias the commands
```
alias vpn_start='sudo ./acp_vpn.sh start'
alias vpn_stop='sudo ./acp_vpn.sh stop'
alias vpn_refresh='sudo ./acp_vpn.sh refresh'
alias vpn_list='sudo ./acp_vpn.sh list'
alias vpn_watch='sudo ./acp_vpn.sh watch'
```

## Selections
A CLI menu comes up for selections. Choices can be selected using `spacebar` and confirmed by pressing `enter`

## Profile Type
This uses the 'Default' profile type from ACP. This can be overwritten to use 'ChromeOS'
