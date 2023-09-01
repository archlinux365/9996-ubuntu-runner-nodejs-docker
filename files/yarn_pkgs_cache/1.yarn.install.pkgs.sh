#!/usr/bin/env bash
set -x
export CMD_PATH=$(cd `dirname $0`; pwd)
export PROJECT_NAME="${CMD_PATH##*/}"
echo $PROJECT_NAME
cd $CMD_PATH
if [ ! -z $1 ];then
  rm -rf packages
fi

. ~/.nvm/nvm.sh
nvm use v14.21.3

unset https_proxy
unset http_proxy
unset HTTPS_PROXY
unset HTTP_PROXY
unset GIT_SSH
unset GIT_PROXY_COMMAND

while read -r line
do
{
  echo "$line"
  mkdir -p packages/$line
  cd packages/$line
  git init
  git checkout master
  git config pull.rebase false
  line2=${line//@}
  git remote add origin git@gitlab.com:graphos/adminos/${line2}.git
  git remote set-url origin git@gitlab.com:graphos/adminos/${line2}.git
  git pull origin master
  rm -rf package-lock.json
  yarn init --yes
  yarn add $line #--verbose
  yarn #--verbose
  yarn list > yarn.list.txt
  p2 "$(date)"
  git remote -v
} &
  cd $CMD_PATH
  
done < 2.packages.list.txt


rm -rf ~/.ssh/
