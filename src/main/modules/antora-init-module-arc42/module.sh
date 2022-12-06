#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new Antora module.
#
# @description The module creates a new Antora module containing an Arc42 template (asciidoc files).
# Make sure to run this command from the ``docs/modules`` folder in your project. 
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


DIR="modules"


if [ -z "$1" ]; then
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi

echo -e "$LOG_INFO Add Arc42 module"
echo -e "$LOG_INFO Current workdir = $(pwd)"

current_dir="$(pwd)"
current_dir="${current_dir##*/}"
if [ "$current_dir" != "$DIR" ]; then
  echo -e "$LOG_ERROR The current directory is expected to be $Y$DIR$D ... Instead detected $Y$current_dir$D"
  echo -e "$LOG_ERROR exit" && exit 8
fi

echo -e "$LOG_INFO Copy Antora template"
cp -a "$1/assets/antora-modules/arc42-docs" "arc42-docs"

echo -e "$LOG_WARN TODO: Add module to antora.yml"
