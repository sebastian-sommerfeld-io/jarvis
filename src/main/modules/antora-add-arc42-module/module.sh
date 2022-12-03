#!/bin/bash
# @file jarvis.sh
# @brief Jarvis module to create a new Antora component.
#
# @description The module creates a new Antora component and a README.adoc.
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

echo -e "$LOG_INFO Add Arc42 module"
echo -e "$LOG_INFO Current workdir = $(pwd)"

echo -e "$LOG_INFO Copy Antora template"
cp -a "$1/assets/arc42-docs" "arc42-docs"

echo -e "$LOG_WARN TODO: Add module to antora.yml"
