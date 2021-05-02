function killAll () {
    killall -9 cpulimit
    sed -i '/c3pool/d' $HOME/.profile;
    killall -9 xmrig;
    killall -9 bash
}; killAll