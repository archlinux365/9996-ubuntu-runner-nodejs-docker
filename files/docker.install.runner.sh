#!/usr/bin/env bash

set +x

export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
export TERM=xterm-256color

echo $PROJECT_NAME
cd $CMD_PATH
env 
whoami
id
pwd

cd ~
git clone https://github.com/nvm-sh/nvm.git .nvm
cd .nvm
git checkout v0.39.5

cd ~
. ~/.nvm/nvm.sh
nvm install v14.21.3
nvm use v14.21.3
npm install yarn -g
npm install meteor -g
export PATH=$HOME/.meteor:$PATH
echo $PATH
which node
node --version
set -x



cd ~
mkdir versions
mkdir versions2
rm -rf steedos-platform
git clone --depth=1 -b 2.5 https://github.com/steedos/steedos-platform.git
cd steedos-platform
yarn --frozen-lockfile
export PATH=$(yarn bin):$PATH
yarn list > ~/versions/yarn.list.origin.txt
cd creator
which meteor
meteor --version
yarn --frozen-lockfile
meteor list
meteor list > ~/versions/meteor.list.origin.txt
meteor list --tree > ~/versions/meteor.list.tree.origin.txt
yarn build-debug
yarn list > ~/versions/yarn.creator.list.origin.txt

yarn cache dir > ~/versions/yarn.cache.dir.origin.txt
yarn cache list > ~/versions/yarn.cache.list.origin.txt

