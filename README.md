# acp-vpn-bash
A bash script for managing ACP VPN profiles using OpenVPN

## Prerequisites
- brew install openvpn

## Run
- `./acp_vpn.sh start all` - Starts all VPN Profiles listed in bash
- `./acp_vpn.sh start` - Opens up selection for user to choose which VPN to start from list in bash
- `./acp_vpn.sh stop all` - Stops all VPN Profiles listed in bash
- `./acp_vpn.sh stop` - Opens up selection for user to choose which VPN to stop from list in bash
- `./acp_vpn.sh refresh all` - Downloads all VPN Profiles listed in bash
- `./acp_vpn.sh refresh` - Opens up selection for user to choose which VPN to download from list in bash
- `./acp_vpn.sh list` - Lists all running OpenVPN processes on your machine
- `./acp_vpn.sh watch` - Watches all running OpenVPN processes on your machine

## Selections
A CLI menu comes up for selections. Choices can be selected using `spacebar` and confirmed by pressing `enter`
