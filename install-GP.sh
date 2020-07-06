#!/bin/bash

if [ $UID -ne 0 ]; then
  echo 'This script requires root access to install packages.'
  echo 'Please relaunch the script using sudo.'
  exit 1
fi

function error-handle {
if [ -z $3 ]; then
  declare -ri expectedCode=0
else
  declare -ri expectedCode=1
fi

if [ $1 -ne $expectedCode ]; then
  echo $2
  echo 'Please try again, if this issue persists; submit a ticket to the IT Service Desk.'
  exit 1
fi
}

echo 'Downloading GlobalProtect VPN Client installer...'
wget -O /tmp/GlobalProtectInstaller.deb https://github.com/YordiDR-LS/Linux-GPInstaller/blob/master/GlobalProtect_CLI-5.1.4.0-9.deb?raw=true &> /dev/null
error-handle $? 'Something went wrong whilst downloading the installer.'

echo 'Installing GlobalProtect VPN Client...'
dpkg -i /tmp/GlobalProtectInstaller.deb
error-handle $? 'Something went wrong whilst installing the GlobalProtect VPN Client.'

rm /tmp/GlobalProtectInstaller.deb

echo 'Downloading script to connect to VPN...'
wget -qO /bin/lsvpn https://raw.githubusercontent.com/YordiDR-LS/Linux-GPInstaller/master/lsvpn.sh
error-handle $? 'Something went wrong whilst downloading the script.'
chmod +x /bin/lsvpn
error-handle $? 'Something went wrong whilst making the script executable.'

echo 'Install complete!'
echo ''
echo "To connect to the Belgian Lansweeper VPN, enter 'lsvpn --connect'."
echo "To disconnect from the Belgian Lansweeper VPN, enter 'lsvpn --disconnect'."

exit 0
