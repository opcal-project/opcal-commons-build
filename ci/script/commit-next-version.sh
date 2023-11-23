#!/bin/bash

set -e

SCRIPT=`readlink -f "${BASH_SOURCE:-$0}"`
SCRIPT_DIR_PATH=`dirname ${SCRIPT}`
CI_DIR_PATH=`dirname ${SCRIPT_DIR_PATH}`
ROOT_PATH=`dirname ${CI_DIR_PATH}`

DEPENDENCIES_FILE=${ROOT_PATH}/dependencies.properties

# tag release
RELEASE_VERSION=$(${ROOT_PATH}/mvnw help:evaluate -Dexpression=project.version | grep "^[^\\[]" |grep -v Download |grep -v Progress | cut -d '-' -f 1)
TAG_NAME=${RELEASE_VERSION}.release
#git tag -a ${TAG_NAME} -m "Release Tag ${RELEASE_VERSION}"
#git push origin ${TAG_NAME}

# next version
${SCRIPT_DIR_PATH}/next-version.sh -${VERSION_DIRECTION:-s}

NEXT_DEVELOPMENT_VERSION=$(cat /tmp/NEXT_DEVELOPMENT_VERSION)

props set ${DEPENDENCIES_FILE} spring-boot.version ${NEXT_DEVELOPMENT_VERSION}

${SCRIPT_DIR_PATH}/dependency-version.sh

${SCRIPT_DIR_PATH}/clean-pom.sh

# commit
git add .
git commit -m "Next development version (${NEXT_DEVELOPMENT_VERSION})"
git push