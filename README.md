<p align="center">
<img width="200" height="200" src="mike.png"/>
</p>

<strong><h2 align="center">DirtyMike</h2></strong> 
<h3 align="center">wget -O - https://b0-b.github.io/DirtyMike/pull.sh | bash</h3>

<br>
<br>

Fully automated &amp; remotely deployable build & control setup for Monero (XMR) pool mining. 

[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Get%20over%20170%20free%20design%20blocks%20based%20on%20Bootstrap%204&url=https://www.froala.com/design-blocks&via=froala&hashtags=bootstrap,design,templates,blocks,developers)

## Features    
- ✅ Nasty installations automated
- ✅ Super quick deploy template file that can trigger arbitrary amount of servers to mine simultaneously
- ✅ Mining yields are directly auto-transferred to your personal wallet
- ✅ Lean back script
- ✅ Automatic benchmark is performed on hardware to evaluate best ALGO (see [here](https://xmrig.com/docs/algorithms))
- ✅ Direct remote execution
- ✅ Detatched mode for remote hosts (ssh does not need to stay alive)
- ✅ Works perfectly on low level PCs - needs only 1 CPU thread and ~4GB (recommended) of RAM
- ✅ Taylored to run on VMs especially on scalable droplets, cronjobs etc.
- ✅ Will only use free CPU power e.g. parallel gaming is possible

## Requirements
- A XMR wallet adrress
- low-level PC, or remote host with rest CPU power
- Ubuntu 20.04 (tested) or debian OS

<strong>DirtyMike</strong> can be build on any host with x64/ARMv8 CPU although the miner was designed to run optimally on x64 architecture (strongly recommended). 

## Dependencies
The `build.sh` script will automatically install:

📌  [xmrig](https://github.com/xmrig/xmrig) - high performance, open source, cross platform RandomX, KawPow, CryptoNight and AstroBWT unified CPU/GPU miner

📌  [cpulimit](https://wiki.ubuntuusers.de/cpulimit/) for usage throttling

📌  [curl](https://curl.se/)

## Getting Started
### 1. Wallet
First get a valid wallet address. If a wallet does not exist yet it can be generated quickly. For this download the official wallet software from [getmonero.org](https://www.getmonero.org/downloads/) and simply follow the instructions.
### 2. Install DirtyMike (Ubuntu/Debian)
```bash
wget -O - https://b0-b.github.io/DirtyMike/pull.sh | bash
```
or
```bash
$ git clone https://github.com/B0-B/DirtyMike.git
$ cd ./DirtyMike
```
### 3. Configuration
Open `build.sh` to alter the config parameters. Exchange your wallet address (mandatory) all other parameters are fine on default for now.
```bash
# ...
# Pool support many ports that are only different by their starting difficulty. Please select them based on your miner speed:
poolPort=17777  #     80: 1000 diff (Firewall bypass)
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
# your wallet public address
wallet=4256HG8... # place it HERE!
# installation directory (DONT change)
InstDIR=$HOME
DIR=$InstDIR/c3pool
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
# ...
```
### 4. Deploy
Run DirtyMike locally in the root directory
```bash
~/DirtyMike$ . build.sh
```
The script will ask a few times to enter your password for installation. When you see the miner running benchmarks in the terminal, you should be fine.
`Note :` If this is the first time calling 

### 5. Deploy Remotely
Remote is triggered using the `-r` flag. The user is then asked to enter hostname and login credentials
```bash
~/DirtyMike$ . build.sh -r

> Hostname: 85.188.250.12
> Login: root
> Password: ...
```
`Note:` If run on servers where the process should be kept alive, please set the detatch in the build.sh to `true`.
Repeat this with arbitrary hosts.

### 6. Monitoring
Go to [c3pool.com](https://c3pool.com/en/) and enter your wallet address to monitor all servers (workers) which mine to your wallet!


### Congratulations you have just started your own miner.

<br>

## Deploy Variants 📡
Every method will ask for remote or local option.
### Simple remote deploy
```bash
. build.sh -r
```

### Kill Worker 
```bash
. build.sh -k
```

### Remove/Uninstall 
```bash
. build.sh -rm
```

### Shuffler (only)
This will run automatically. 
```bash
. build.sh -s
```

## Issues
