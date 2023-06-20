#!/bin/bash
# @file log.sh
# @brief Bash module which provides utility functions for logging.
#
# @description The script is bash module which provides utility functions for logging. This
# module is part of the link:https://github.com/sebastian-sommerfeld-io/jarvis[Jarvis project].
#
# Include in your script by using the following snippet:
# [source, bash]
# ```
# #!/bin/bash
#
# # Some code if needed but make sure to include this module somewhere at the top of your script
#
# rm -rf /tmp/bash-lib
# mkdir -p /tmp/bash-lib
# curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/bash-logging-module/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh
# source /tmp/bash-lib/log.sh
# ```
#
# CAUTION: This script is a module an is not intended to run on its own. Include in script and
# use its functions!
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace



export LEVEL_DONE="[\e[32mDONE\e[0m]"
export LEVEL_ERROR="[\e[1;31mERROR\e[0m]"
export LEVEL_INFO="[\e[34mINFO\e[0m]"
export LEVEL_WARN="[\e[93mWARN\e[0m]"
export Y="\e[93m"
export P="\e[35m"
export D="\e[0m"
export G="\033[1;30m"


# @description Log message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  echo -e "$LEVEL_ERROR [$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

export -f LOG_ERROR


# @description Log message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  echo -e "$LEVEL_INFO [$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

export -f LOG_INFO


# @description Log message with log level = DONE.
#
# @arg $@ String The line to print.
function LOG_DONE() {
  echo -e "$LEVEL_DONE [$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

export -f LOG_DONE


# @description Log message with log level = WARN.
#
# @arg $@ String The line to print.
function LOG_WARN() {
  echo -e "$LEVEL_WARN [$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

export -f LOG_WARN


# @description Print log output in a header-style.
#
# @arg $@ String The line to print.
function LOG_HEADER() {
  LOG_INFO "------------------------------------------------------------------------"
  LOG_INFO "$1"
  LOG_INFO "------------------------------------------------------------------------"
}

export -f LOG_HEADER
