#!/bin/bash

set -e

SCRIPT=$(readlink -f "${BASH_SOURCE:-$0}")
SCRIPT_DIR_PATH=$(dirname "${SCRIPT}")
CI_DIR_PATH=$(dirname "${SCRIPT_DIR_PATH}")
ROOT_PATH=$(dirname "${CI_DIR_PATH}")

DEPENDENCIES_FILE="${ROOT_PATH}"/dependencies.properties

# tag release
RELEASE_VERSION=$("${ROOT_PATH}"/mvnw help:evaluate -Dexpression=project.version | grep "^[^\\[]" |grep -v Download |grep -v Progress | cut -d '-' -f 1)
TAG_NAME=${RELEASE_VERSION}.release

"${SCRIPT_DIR_PATH}"/versions-set.sh "${RELEASE_VERSION}"
"${ROOT_PATH}"/mvnw flatten:clean

git add .
git commit -m "[skip ci] On Branch Bump Release ${RELEASE_VERSION}"
git push -o ci.skip -o integrations.skip_ci

git tag -a "${TAG_NAME}" -m "Release Tag ${RELEASE_VERSION}"
git push origin "${TAG_NAME}"

# next version
"${SCRIPT_DIR_PATH}"/next-version.sh -"${VERSION_DIRECTION:-s}"

"${ROOT_PATH}"/mvnw flatten:clean
"${SCRIPT_DIR_PATH}"/clean-pom.sh

NEXT_DEVELOPMENT_VERSION=$(cat /tmp/NEXT_DEVELOPMENT_VERSION)

"${ROOT_PATH}"/mvnw clean compile versions:property-updates-aggregate-report -DallowSnapshots=true

export WORKSPACE=${ROOT_PATH}
versions check "${ROOT_PATH}"/ci/maven/version.yml

"${SCRIPT_DIR_PATH}"/dependency-version.sh

"${SCRIPT_DIR_PATH}"/clean-pom.sh

# commit
git add .
git commit -m "Next development version (${NEXT_DEVELOPMENT_VERSION})"
git push