#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new bash script and apply basic config.
#
# @description The module creates a new bash script and apply basic config. The script contains basic
# shdoc comments, some default options like ``set -o nounset`` and marks the scripts as executable.
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


# @description Log message with log level = DONE.
#
# @arg $@ String The line to print.
function LOG_DONE() {
  local LOG_DONE="[\e[32mDONE\e[0m]"
  echo -e "$LOG_DONE $1"
}


# @description Log message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  local LOG_ERROR="[\e[1;31mERROR\e[0m]" 
  echo -e "$LOG_ERROR $1"
}


# @description Log message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  local LOG_INFO="[\e[34mINFO\e[0m]"
  echo -e "$LOG_INFO $1"
}


# @description Log message with log level = WARN.
#
# @arg $@ String The line to print.
function LOG_WARN() {
  local LOG_WARN="[\e[93mWARN\e[0m]"
  echo -e "$LOG_WARN $1"
}


# @description Print log output in a header-style.
#
# @arg $@ String The line to print.
function LOG_HEADER() {
  LOG_INFO "------------------------------------------------------------------------------------"
  LOG_INFO "$1"
  LOG_INFO "------------------------------------------------------------------------------------"
}


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi



LOG_HEADER "Create bash script and apply basic config"


LOG_INFO "Enter filename (with ending):"
read -r FILENAME
readonly FILENAME

if [ -f "$FILENAME" ]; then
  LOG_ERROR "File $FILENAME already existing"
  LOG_ERROR "exit" && exit 4
fi

cp "$1/assets/template.sh" "$FILENAME"
old="__FILENAME__"
sed -i "s|$old|$FILENAME|g" "$FILENAME"
chmod +x "$FILENAME"

LOG_DONE "Created $FILENAME"
