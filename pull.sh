#!/bin/bash
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")" ]; then
  sudo apt-get --yes install git 
fi
cd $HOME
sudo git clone https://github.com/B0-B/DirtyMike.git &&
xdg-open "$HOME/DirtyMike/build.sh"