#!/bin/bash
# @file log.sh
# @brief Bash module which provides utility functions for logging.
#
# @description The script is bash module which provides a logging library for Bash scripts. This
# module is part of the link:https://github.com/sebastian-sommerfeld-io/jarvis[Jarvis project].
#
# It allows you to log messages with different log levels (debug, info, warning and error). 
#
# This module is intended to show log information to user who interacts with the bash command line.
# So all output is written to ``stdout``. By default this module does not write to any files. To log
# to files, redirect the output to a file of your choice (``LOG_INFO "Some log line" >> some.log``). 
#
# To use the logger library, include the following line in your Bash script:
# [source, bash]
# ```
# #!/bin/bash
#
# # Some code if needed but make sure to include this module somewhere at the top of your script
#
# # Download and include logging library
# rm -rf /tmp/bash-lib
# mkdir -p /tmp/bash-lib
# curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh
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


# @description Private function to get the current date (propperly formated) to include in log lines.
function __date() {
  echo -e "${G}$(date '+%Y-%m-%d %H:%M:%S')${D}"
}

export -f __date


# @description Log a message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  echo -e "$LEVEL_ERROR $(__date) $1"
}

export -f LOG_ERROR


# @description Log a message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  echo -e "$LEVEL_INFO $(__date) $1"
}

export -f LOG_INFO


# @description Log a message with log level = DONE.
#
# @arg $@ String The line to print.
function LOG_DONE() {
  echo -e "$LEVEL_DONE $(__date) $1"
}

export -f LOG_DONE


# @description Log a message with log level = WARN.
#
# @arg $@ String The line to print.
function LOG_WARN() {
  echo -e "$LEVEL_WARN $(__date) $1"
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
