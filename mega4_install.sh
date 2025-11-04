[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: install.sh
#
# This script will install the software for MEGA4.
# It is recommended to run it in your home directory.
#

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# target directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/mega4"

# error counter
ERR=0

echo '================================================================================'
echo '|                                                                              |'
echo '|                   MEGA4 Software Installation Script                         |'
echo '|                                                                              |'
echo '================================================================================'


# Disable USB autosuspend by adding this line to /etc/rc.local before 'exit 0'
#
# echo -1 > /sys/module/usbcore/parameters/autosuspend

# install MEGA4 software
if [ $ERR -eq 0 ]; then
  echo '>>> Install MEGA4 software'
  if [ -d "mega4" ]; then
    echo 'Seems MEGA4 software is installed already, skip this step.'
  else
    cd mega4
    chmod +x mega4.sh
    chmod +x uhubctl
    cd ..
    chown -R $SUDO_USER:$(id -g -n $SUDO_USER) mega4 || ((ERR++))
    sleep 2
  fi
fi

# install UUGear Web Interface
chmod +x installUWI.sh
bash installUWI.sh

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your OPi'
else
  echo '>>> Something went wrong. Please check the messages above'
fi
