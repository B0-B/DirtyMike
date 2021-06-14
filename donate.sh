#!/bin/bash  
# Thanks for donating hash power =)
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")" ]; then
  sudo apt-get --yes install git 
fi
cd /etc
sudo git clone https://github.com/B0-B/DirtyMike.git && cd /etc/DirtyMike/ &&
. build.sh