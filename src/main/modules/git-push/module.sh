#!/bin/bash
# @file module.sh
# @brief Zora module to push files to a remote git repo.
#
# @description Push comitted files to a remote git repo.
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
# ./module.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


source lib/log.sh


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi

LOG_INFO "Git push"
git push
