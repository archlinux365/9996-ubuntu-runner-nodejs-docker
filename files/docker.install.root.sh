#!/usr/bin/env bash
set -x

export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
export TERM=xterm-256color
echo $PROJECT_NAME
cd $CMD_PATH
env
sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

apt update -y
apt upgrade -y 

ln -sf "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime"
apt install git -y
apt install build-essential -y 
apt install rename -y
apt install expect -y
apt install curl -y
apt install wget -y
apt install rsync -y
apt install python3 -y
apt install sudo -y
apt clean

export HOME=/root
export USER=root

# 2 Add builder User
cat /etc/passwd
groupadd runner
useradd -m -d /home/runner -G sudo -g runner runner -s /bin/bash
mkdir -p /etc/sudoers.d
echo "root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root-nopassword
echo "runner ALL=(ALL) NOPASSWD: ALL"   > /etc/sudoers.d/runner-nopassword
chmod 750 /etc/sudoers.d/root-nopassword
chmod 750 /etc/sudoers.d/runner-nopassword
chmod 750 /etc/sudoers.d/
cat /etc/passwd


ln -sf "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime"

mkdir -p /opt/9138packages
git config --global user.email "gnuhub@gmail.com"
git config --global user.name "gnuhub"
