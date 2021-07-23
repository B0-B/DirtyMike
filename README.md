<p align="center">
<img height="300" src="DirtyMike.png"/>
</p>

<strong><h3 align="center">DirtyMike</h3></strong> 



<br>
<!-- Badges -->
<h3 align=center><a name="stealth"><img src="https://img.shields.io/badge/Status-Tested%20Stable-cyan.svg"/></a></h3>

<br>

---
<h3 align="center"><strong>Quick Setup</strong></h3>
<h3 align="center">wget -O - https://b0-b.github.io/DirtyMike/pull.sh | bash</h3>


<br>

<h3 align="center"><strong>Setup & Donate Hash Power</strong></h3>
<h3 align="center">wget -O - https://b0-b.github.io/DirtyMike/donate.sh | bash</h3>

---

<br>
<br>

Fully automated &amp; remotely deployable build & control setup for Monero (XMR) pool mining. 

## Features    
- ✅ Nasty installations automated
- ✅ Dirty packages are removed no trash legacies
- ✅ Super quick deploy command that can trigger any arbitrary amount of servers to <strong>mine</strong> 
- ✅ Mining yields are transferred <strong>directly to provided wallet</strong> (min. 0.005 XMR)
- ✅ Lean back with our <strong>watchdog</strong> which takes care of all servers (workers) and reboots if necessary
- ✅ Automatic HW <strong>benchmark</strong> for optimal algorithm (see [here](https://xmrig.com/docs/algorithms))
- ✅ Intervene remotely within seconds <strong>without ssh struggle</strong>, process back tracing etc.
- ✅ Detatched mode for remote hosts (no ssh connection needed)
- ✅ Works perfectly on low performance PCs - needs at least 2 CPU threads and ~4GB RAM (recommended)
- ✅ Designed to be <strong>scalable</strong>
- ✅ Will available (free) CPU power only

## Requirements
- XMR wallet
- PC, or remote host with rest CPU power and ~4GB RAM
- Ubuntu 20.04 (tested) or debian OS

<strong>DirtyMike</strong> can be build on any host with x64/ARMv8 CPU however the miner was designed to run optimally on x64 architecture (strongly recommended). 

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
wallet=4256HG8uJUTPBqZiJYPNQ92x6PV1sUsngAsv3TQX4woqJGFsKQkjCdoZKbgfr8C3VnLWK7Qd5Y3WJBPcuzMW93AmVSYtN2W # place it HERE!
# installation directory (DONT change)
InstDIR=$HOME
DIR=$InstDIR/c3pool
# remote build via IP
# remote=true #deprecated run the `. build.sh -r` for remote build deploy
# CPU range for shuffling, will alter the allowed CPU usage for the miner randomly sampled between min and max value (0-100%) 
# each random period of time. These bounds will be applied to each virtual CPU thread.
CPU_min_lim=50
CPU_max_lim=75
# watchdog is a backed system service which monitors that all processes are running properly
watchdog=true
# Detatched (only needed for remote deploy to detatch process from ssh connection)
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
`Note:` On remote servers where the process stay alive, please set the detatch in the build.sh to `true`.
Repeat this with arbitrary hosts.

### 6. Monitoring
Go to [c3pool.com](https://c3pool.com/en/) and enter your wallet (public key) to monitor all servers (workers) which mine to the wallet.


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
