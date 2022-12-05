#!/bin/bash
# @file module.sh
# @brief Jarvis module to create default (static) github actions.
#
# @description The module creates default github actions. Make sure to run this command from your
# ``.github`` folder. The module only creates static workflows which are exactly the same for all
# repositories.
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

echo -e "$LOG_INFO Add default github action workflows"
echo -e "$LOG_INFO Current workdir = $(pwd)"

echo -e "$LOG_INFO Copy workflows and workflow assets"
cp -a "$1/assets/workflows/assets" "assets"
cp "$1/assets/workflows/organize.yml" "organize.yml"
