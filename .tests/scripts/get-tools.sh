#!/usr/bin/env bash

# NOTE: Parsing curl to tac to circumnvent "failed writing body"
# https://stackoverflow.com/questions/16703647/why-curl-return-and-error-23-failed-writing-body

set -e
set -u
set -o pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" && pwd -P )"
DVLBOX_PATH="$( cd "${SCRIPT_PATH}/../.." && pwd -P )"
# shellcheck disable=SC1090
. "${SCRIPT_PATH}/.lib.sh"

RETRIES=10

TEST_REPO="https://github.com/john-ea/docker-php-fpm"

# -------------------------------------------------------------------------------------------------
# FUNCTIONS
# -------------------------------------------------------------------------------------------------
PHP_TAG="$( grep 'johnea/php' "${DVLBOX_PATH}/docker-compose.yml" | sed -E 's/^.*-work[-]?//g')"
if [ -z "${PHP_TAG}" ]; then
	PHP_TAG="$( run "git ls-remote --symref ${TEST_REPO} | head -1 | cut -f1 | sed 's!^ref: refs/heads/!!'" "${RETRIES}" )";
fi
PHP_TOOLS="$( run "curl -sS 'https://raw.githubusercontent.com/john-ea/docker-php-fpm/${PHP_TAG}/doc/available-tools.md'" "${RETRIES}" )";

echo "${PHP_TOOLS}" | grep -A 1000000 'TOOLS_WORK_START'
