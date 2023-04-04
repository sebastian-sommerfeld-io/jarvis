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


source lib/log.sh


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
