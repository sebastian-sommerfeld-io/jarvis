#!/bin/bash
# @file module.sh
# @brief Jarvis module to update the Jarvis installation.
#
# @description The module updates the Jarvis installation
#
# NOTE: Don't run this script directly! Always run the ``jarvis`` command and select the module of choice.
#
# === Script Arguments
#
# * *$1* (string): The path from jarvis.sh to this module (modules/<MODULE_NAME>)
#
# === Script Example
#
# [source, bash]
# ```
# jarvis
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


if [ -z "$1" ]; then
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi

echo -e "$LOG_INFO ======================================================================================================="
echo -e "$LOG_INFO Update jarvis"
echo -e "$LOG_INFO Current workdir = $(pwd)"
if [ "$IS_DEV" = "true" ]; then
  echo -e "$LOG_WARN ${Y}Running from local development project${D}"
fi
echo -e "$LOG_INFO ======================================================================================================="

curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/install.sh | bash -
