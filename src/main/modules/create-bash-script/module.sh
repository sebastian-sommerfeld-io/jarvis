#!/bin/bash
# @file jarvis.sh
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


if [ -z "$1" ]; then
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi


echo -e "$LOG_INFO Create bash script and apply basic config"
echo -e "$LOG_INFO Current workdir = $(pwd)"


echo -e "$LOG_INFO Enter filename (with ending):"
read -r FILENAME


if [ -f "$FILENAME" ]; then
  echo -e "$LOG_ERROR File $FILENAME already existing"
  echo -e "$LOG_ERROR exit" && exit 4
fi


cp "$1/assets/template.sh" "$FILENAME"
old="__FILENAME__"
sed -i "s|$old|$FILENAME|g" "$FILENAME"
chmod +x "$FILENAME"


echo -e "$LOG_DONE Created $FILENAME"
