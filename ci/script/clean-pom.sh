#!/bin/bash

SCRIPT=`readlink -f "${BASH_SOURCE:-$0}"`
SCRIPT_DIR_PATH=`dirname ${SCRIPT}`
CI_DIR_PATH=`dirname ${SCRIPT_DIR_PATH}`
ROOT_PATH=`dirname ${CI_DIR_PATH}`

rm -f ${ROOT_PATH}/.flattened-pom.xml
rm -f ${ROOT_PATH}/pom.xml.versionsBackup
rm -f ${ROOT_PATH}/**/.flattened-pom.xml
rm -f ${ROOT_PATH}/**/pom.xml.versionsBackup