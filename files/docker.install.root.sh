#!/usr/bin/env bash
set -x

export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
export TERM=xterm-256color
echo $PROJECT_NAME
cd $CMD_PATH
env


sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
sed -i 's/#\(zh_CN\.UTF-8\)/\1/' "/etc/locale.gen"
locale-gen
ln -sf "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime"

export HOME=/root
export USER=root

# 2 Add builder User
cat /etc/passwd
groupadd runner
useradd -m -d /home/runner -G wheel -g runner runner -s /bin/bash
mkdir -p /etc/sudoers.d
echo "root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root-nopassword
echo "runner ALL=(ALL) NOPASSWD: ALL"   > /etc/sudoers.d/runner-nopassword
chmod 750 /etc/sudoers.d/root-nopassword
chmod 750 /etc/sudoers.d/runner-nopassword
chmod 750 /etc/sudoers.d/
cat /etc/passwd


# Prepare livesession settings and user
sed -i 's/#\(en_US\.UTF-8\)/\1/' "/etc/locale.gen"
sed -i 's/#\(zh_CN\.UTF-8\)/\1/' "/etc/locale.gen"

locale-gen

ln -sf "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime"

mkdit -p /opt/9138packages
git config --global user.email "gnuhub@gmail.com"
git config --global user.name "gnuhub"
