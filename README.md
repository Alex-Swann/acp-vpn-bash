# acp-vpn-bash
A bash script for managing ACP VPN profiles using OpenVPN.
ACP VPN profiles - https://access-acp.digital.homeoffice.gov.uk/ui/profiles

When refreshing VPN profiles, Chrome browser is opened to authenticate using 365 if needs be. Otherwise VPNs are downloaded automatically and Chrome tabs closed. Then the latest VPN downloaded of the desired profile is used, and any others older than 2 days old are removed from the specified download folder.

Any VPNs restarted with ensure to remove any historically running instances to ensure there aren't duplicate VPN of the same profile name running. The PID is discovered and this is used to determine any preexisting VPNs of the same profile name running.

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
You can add the following to your `~/.bashrc`, `~/.bash_profile`, or `~/.zshrc` profiles to alias the following commands:
```
alias vpn_start="sudo $HOME/Documents/acp-vpn-bash/acp_vpn.sh start"
alias vpn_stop="sudo $HOME/Documents/acp-vpn-bash/acp_vpn.sh stop"
alias vpn_refresh="sudo $HOME/Documents/acp-vpn-bash/acp_vpn.sh refresh"
alias vpn_list="sudo $HOME/Documents/acp-vpn-bash/acp_vpn.sh list"
alias vpn_watch="sudo $HOME/Documents/acp-vpn-bash/acp_vpn.sh watch"
```
Then `source` the relevant profile (e.g. `source ~/.bashrc`) if using an already open terminal tab to ensure they are then accessible. Otherwise a new terminal window should incorporate these aliases already.

## Selections
A CLI menu comes up for selections. Choices can be selected using `spacebar` and confirmed by pressing `enter`

## Profile Type
This uses the 'Default' profile type from ACP. This can be overwritten to use 'ChromeOS'

## Troubleshooting
If you get any issues like the following:
```
sudo: ./acp_vpn.sh: command not found
```
You can run the following that should resolve the issue:
```
chmod 777 acp_vpn.sh
```
