#!/bin/bash
# @file jarvis.sh
# @brief Entrypoint to the jarvis bash utility.
#
# @description The script is the entrypoint to the jarvis bash utility. The scripts provides a select menu
# to choose which module to run.
#
# Something about /opt/jarvis
#
# === Script Arguments
#
# The script does not accept any parameters.
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


# @description Log message with log level = DONE.
#
# @arg $@ String The line to print.
function LOG_DONE() {
  local LOG_DONE="[\e[32mDONE\e[0m]"
  echo -e "$LOG_DONE $1"
}

export -f LOG_DONE


# @description Log message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  local LOG_ERROR="[\e[1;31mERROR\e[0m]" 
  echo -e "$LOG_ERROR $1"
}

export -f LOG_ERROR


# @description Log message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  local LOG_INFO="[\e[34mINFO\e[0m]"
  echo -e "$LOG_INFO $1"
}

export -f LOG_INFO


# @description Log message with log level = WARN.
#
# @arg $@ String The line to print.
function LOG_WARN() {
  local LOG_WARN="[\e[93mWARN\e[0m]"
  echo -e "$LOG_WARN $1"
}

export -f LOG_WARN


# @description Print log output in a header-style.
#
# @arg $@ String The line to print.
function LOG_HEADER() {
  LOG_INFO "------------------------------------------------------------------------------------"
  LOG_INFO "$1"
  LOG_INFO "------------------------------------------------------------------------------------"
}

export -f LOG_HEADER


MODULES_PATH=""
if [ "$0" = "/usr/bin/jarvis" ]; then
  MODULES_PATH="/opt/jarvis/src/main/"
fi
readonly MODULES_PATH


LOG_HEADER "Current workdir = $(pwd)"


LOG_INFO "What do you want me to do?"
select module in "$MODULES_PATH"modules/*; do
  bash "$module/module.sh" "$module"
  break
done
