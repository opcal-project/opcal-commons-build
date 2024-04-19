#!/bin/bash

## install versions
## curl -sL https://raw.githubusercontent.com/gissily/versions-tools/main/install.sh | sudo bash

set -e

SCRIPT=$(readlink -f "${BASH_SOURCE:-$0}")
SCRIPT_DIR_PATH=$(dirname "${SCRIPT}")
CI_DIR_PATH=$(dirname "${SCRIPT_DIR_PATH}")
ROOT_PATH=$(dirname "${CI_DIR_PATH}")

UPDATE_FLAG=/tmp/versionUpdate

if [ -f "${UPDATE_FLAG}" ];then

  echo "update versions"
  "${SCRIPT_DIR_PATH}"/dependency-version.sh

  message=$(cat ${UPDATE_FLAG})
  git add .
  git commit -m "${message}"
  git push

else
  echo "no updates"
fi
