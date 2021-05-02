#!/usr/bin/env bash                                   
echo '
                                         ____  _     _       _____ _ _       
                                        |    \|_|___| |_ _ _|     |_| |_ ___ 
                                        |  |  | |  _|  _| | | | | | | ,_| -_|
                                        |____/|_|_| |_| |_  |_|_|_|_|_,_|___|
                                                        |___|                
'

###################################################### PARAMETERS #############################################################
# Pool support many ports that are only different by their starting difficulty. Please select them based on your miner speed:
#     80: 1000 diff (Firewall bypass)
#     443: 1000 diff (Firewall bypass)
#     13333: 25000 diff (auto-adjust)
#     14444: 25000 diff (auto-adjust)
#     15555: 50000 diff (auto-adjust)
#     17777: 50000 diff (auto-adjust)
#     19999: 100000 diff (auto-adjust)
#     23333: 1000000 diff (Proxy/NiceHash)
#     33333: 15000 diff (SSL)
#     43333: 2G diff (ETH port)
#     53333: 2G diff (ETH port/SSL/TLS)
poolPort=17777
# your wallet public address
wallet=4256HG8uJUTPBqZiJYPNQ92x6PV1sUsngAsv3TQX4woqJGFsKQkjCdoZKbgfr8C3VnLWK7Qd5Y3WJBPcuzMW93AmVSYtN2W
# installation directory (DONT change)
DIR=$HOME/c3pool
# remote build via IP
# remote=true #deprecated run the `. build.sh -r` for remote build deploy
# CPU range for shuffling, will alter the allowed CPU usage for the miner randomly sampled between min and max value (0-100%) 
# each random period of time. These bounds will be applied to each virtual CPU thread.
CPU_min_lim=55
CPU_max_lim=85

###############################################################################################################################



# ======== c3Pool setup script for Monero Miner ======== 
function killAll () {
    sed -i '/c3pool/d' $HOME/.profile
    killall -9 xmrig
}
function stopService () {
    systemctl stop c3pool_miner.service
}
function removeService () {
    echo "[*] Removing c3pool miner"
    if sudo -n true 2>/dev/null; then
        sudo systemctl stop c3pool_miner.service
        sudo systemctl disable c3pool_miner.service
        sudo rm -f /etc/systemd/system/c3pool_miner.service
        sudo systemctl daemon-reload
        sudo systemctl reset-failed
    fi
}
function CPU_threads () {
    # echo $(cpuThreads)
    grep -c ^processor /proc/cpuinfo
}
function shuffle () {
    sleep 1;
    while true;
    do echo "shuffle CPU limit ...";
    lim=`echo $(shuf -i$CPU_min_lim-$CPU_max_lim -n1)`;
    threads=`echo $(grep -c ^processor /proc/cpuinfo)`;
    echo "[CPU threads]:" $threads
    echo "[CPU limiter]: limiting CPU usage to $lim% ...";
    echo upper limit $(($threads*$lim));
    cpulimit -e xmrig -l $(($threads*$lim)) & # 2 t/c
    sleep $(shuf -i15-45 -n1);
    pkill cpulimit; 
    sleep 1; done
}
function runMiner () {
    . $DIR/miner.sh;
}
function setPort () {
    jsonFile=$DIR/config.json;
    lines=''
    while read line; 
    do 
        # override url port value in json
        line="$line"
        if [[ $line == *url* ]]; then
            echo 'url found' $line
            line='"url":"mine.c3pool.com:'$poolPort'",'
        fi
        lines+=$line
    done < $jsonFile;
    echo $lines > $jsonFile
}
function install () {
    if [ ! -d "$DIR" ]; then
        echo installing XMR mining setup ... [FFA]
        sudo apt update &&
        sudo apt install -y curl && sudo apt install -y cpulimit
        curl -s -L https://raw.githubusercontent.com/C3Pool/xmrig_setup/master/setup_c3pool_miner.sh | bash -s $wallet
        setPort
    else
        echo installation found at $DIR
    fi   
}
function refresh () {
    sudo systemctl daemon-reload
    sudo systemctl reset-failed
}
function build () {
    install && removeService
    wait
    shuffle &
    runMiner
}

# run build
if [[ "$1" == "-r" ]]; then # draw host credentials
    echo $USER deploying build remotely at $IP ...
    echo "Hostname: ";read IP;echo "Login: ";read USER
    scp -r ./* $USER@$IP:/home && \
    cat ./build.sh | ssh $USER@$IP /bin/bash
else # build locally
    build
fi