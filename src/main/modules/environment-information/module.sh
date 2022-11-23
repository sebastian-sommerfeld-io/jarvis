#!/bin/bash
# @file module.sh
# @brief Jarvis module to print information about the current system.
#
# @description The module prints information abut the current Linux environment.
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


echo -e "$LOG_INFO ========== System Info =================================================="
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Uptime: $(uptime --pretty)"
echo -e "$LOG_INFO ========================================================================="
