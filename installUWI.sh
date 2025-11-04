[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: installUWI.sh
#
# This script will install UUGear Web Interface (UWI).
# It is recommended to run it in your home directory.
#

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

# target directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/uwi"

# error counter
ERR=0

echo '================================================================================'
echo '|                                                                              |'
echo '|          UUGear Web Interface (UWI) Installation Script                      |'
echo '|                                                                              |'
echo '================================================================================'


# install UUGear Web Interface (UWI)
if [ $ERR -eq 0 ]; then
  echo '>>> Install/update UWI'
#  wget https://www.uugear.com/repo/UWI/LATEST -O uwi.zip || ((ERR++))
#  unzip uwi.zip -d uwi.latest || ((ERR++))
  cd uwi
  chmod +x messanger.sh
  chmod +x websocketd
  chmod +x uwi.sh
  chmod +x diagnose.sh
  sed -e "s#/home/orangepi/uwi#$DIR#g" uwi >/etc/init.d/uwi
  chmod +x /etc/init.d/uwi
  update-rc.d uwi defaults || ((ERR++))
  touch uwi.log
  cd ..
  chown -R $SUDO_USER:$(id -g -n $SUDO_USER) uwi || ((ERR++))
  sleep 2
  
#  if [ -d "uwi" ]; then
#    cur_ver=$(cat uwi/common/js/common.js | grep 'var version =' | sed "s/var version = '//" | sed "s/';//")
#    latest_ver=$(cat uwi.latest/common/js/common.js | grep 'var version =' | sed "s/var version = '//" | sed "s/';//")
#    echo ''
#    echo "Current UWI version=${cur_ver}, latest UWI version=${latest_ver}"
#    if (( $(echo "$latest_ver $cur_ver" | awk '{print ($1 > $2)}') )); then
#      echo "UUGear Web Interface (UWI) was installed but there is a newer version now."
#      postfix=$(tr -dc A-Z0-9 </dev/urandom | head -c 3)
#      echo "The current version will be moved to 'uwi_${postfix}'. [Please delete it after review]"
#      echo "The latest version will be installed to 'uwi' directory."
#      mv uwi "uwi_${postfix}"
#      mv uwi.latest uwi
#    else
#      echo "UUGear Web Interface (UWI) is installed and there is no newer version now."
#      rm -R uwi.latest
#    fi
  else
    mv uwi uwi
#  fi
fi

echo
if [ $ERR -eq 0 ]; then
  echo '>>> All done. Please reboot your Pi to have UWI server running :-)'
  echo 'With default settings, the web interface URL is http://max.local:8000/'
  echo "If you have problem accessing UWI from another device, please run the 'diagnose.sh' script in 'uwi' directory."
else
  echo '>>> Something went wrong. Please check the messages above :-('
fi
