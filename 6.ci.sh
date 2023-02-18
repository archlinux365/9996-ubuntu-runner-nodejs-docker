#!/usr/bin/env bash

set -x

export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
export TERM=xterm-256color

echo $PROJECT_NAME
cd $CMD_PATH

cp -fv known_hosts /home/runner/.ssh/known_hosts
ssh-keygen -f "/home/runner/.ssh/known_hosts" -R "frs.sourceforge.net"
ssh-keyscan "frs.sourceforge.net" >> /home/runner/.ssh/known_hosts
ssh-keygen -f "/home/runner/.ssh/known_hosts" -R "github.com"
ssh-keyscan "github.com" >> /home/runner/.ssh/known_hosts
cat /home/runner/.ssh/known_hosts

env
docker build . -f Dockerfile.$GITHUB_REF_NAME \
-t ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER -t ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest \
-t gnuhub/$PROJECT_NAME-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER -t gnuhub/$PROJECT_NAME-$GITHUB_REF_NAME:latest \
-t hkccr.ccs.tencentyun.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER -t hkccr.ccs.tencentyun.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest \
-t registry.cn-hangzhou.aliyuncs.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER -t registry.cn-hangzhou.aliyuncs.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest


docker push ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER
docker push ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest
docker push registry.cn-hangzhou.aliyuncs.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER
docker push registry.cn-hangzhou.aliyuncs.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest
docker push hkccr.ccs.tencentyun.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER 
docker push hkccr.ccs.tencentyun.com/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:latest 
docker push gnuhub/$PROJECT_NAME-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER
docker push gnuhub/$PROJECT_NAME-$GITHUB_REF_NAME:latest

docker run ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER pacman -Sl > release.$GITHUB_RUN_NUMBER.packages.list.all.txt
docker run ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER pacman -Qe > release.$GITHUB_RUN_NUMBER.packages.list.installed.txt

cd ~/
git clone git@github.com:archlinux365/9318-archlinux-docker.git

cd 9318-archlinux-docker

docker run ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER pacman -Sl > packages.list.all.txt
docker run ghcr.io/${GITHUB_REPOSITORY}-$GITHUB_REF_NAME:$GITHUB_RUN_NUMBER pacman -Qe > packages.list.installed.txt

cd ~/

git clone https://github.com/archlinux/aur.git
cd aur
git branch -a | sed 's#  remotes/origin/##g' | grep -v "main" > ~/9318-archlinux-docker/aur.all.txt

cd ~/
cd 9318-archlinux-docker


git config --global user.email "gnuhub@gmail.com"
git config --global user.name "gnuhub"
git add .
git commit -a -m "CI-BOT:$(date +%Y.%m.%d-%H%M%S)-$GITHUB_REF_NAME-$GITHUB_RUN_NUMBER"
git push origin root 

git checkout runner 
git merge root 
git push origin runner
