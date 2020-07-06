#!/bin/bash

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

function connect {
sudo systemctl status gpd | grep 'running' &> /dev/null
if [ $? -ne 0 ]; then
  echo 'Starting the GlobalProtect service... (this may prompt for a sudo password)'
  sudo systemctl start gpd &> /dev/null
  error-handle $? 'Something went wrong whilst starting the GlobalProtect service. Is the VPN client installed?'
fi

echo 'Connecting to the Belgian Lansweeper VPN...'
globalprotect connect --portal gp.lansweeper.com
error-handle $? 'Something went wrong whilst connecting to the Belgian Lansweeper VPN.' 1

declare -r interface=$(ip route | grep '192.168.0.0/22' | perl -nle 'if ( /dev\s+(\S+)/ ) {print $1}')
error-handle $? 'Something went wrong whilst determining the VPN interface.'

echo 'Adding static routes to Lansweeper devices...'
sudo ip route add 192.168.1.201 dev $interface &> /dev/null
error-handle $? 'Something went wrong whilst adding the required routes.'
sudo ip route add 192.168.1.251 dev $interface &> /dev/null
error-handle $? 'Something went wrong whilst adding the required routes.'

echo 'All done!'
exit 0
}

function disconnect {
  echo 'Stopping the GlobalProtect service... (this may prompt for a root password)'
  sudo systemctl stop gpd &> /dev/null
  error-handle $? 'Something went wrong whilst stopping the GlobalProtect service.'
}

case $1 in
  '--connect' | '-c')
    connect
    ;;

  '--disconnect' | '-d')
    disconnect
    ;;
  *)
    echo 'Script usage:'
    echo '  -c --connect	Connect to the Belgian Lansweeper VPN'
    echo '  -d --disconnect	Disconnect from the currently connected VPN'
esac

exit 0
