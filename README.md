# Linux-GPInstaller
This repository contains the necessary files to automatically install the GlobalProtect VPN client. It also installs a script to connect to the Lansweeper Belgian Office.

Oneliner to install everything:
```bash
sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/YordiDR-LS/Linux-GPInstaller/master/install-GP.sh)" root
``` 

Command used to connect to the VPN:
```bash
lsvpn --connect
``` 
