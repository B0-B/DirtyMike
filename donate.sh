#!/bin/bash  
# Thanks for donating hash power =)
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")" ]; then
  sudo apt-get --yes install git 
fi
cd $HOME
sudo git clone -b dev https://github.com/B0-B/DirtyMike.git && cd $HOME/DirtyMike/ &&
. build.sh