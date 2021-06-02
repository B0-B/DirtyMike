#!/bin/bash
if [ "" = "$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")" ]; then
  sudo apt-get --yes install git 
fi
cd $HOME
git clone https://github.com/B0-B/DirtyMike.git && cd "$HOME/DirtyMike/"
xdg-open "$HOME/DirtyMike/build.sh"
