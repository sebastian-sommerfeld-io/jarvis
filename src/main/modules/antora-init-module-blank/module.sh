#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new Antora module.
#
# @description The module creates a new blank Antora module Make sure to run this command from the
# ``docs/modules`` folder in your project.
#
# NOTE: Don't run this script directly! Always run the ``jarvis`` command and select the module of choice.
#
# === Script Arguments
#
# * *$1* (string): The path from jarvis.sh to this module (``modules/<MODULE_NAME>``)
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


readonly EXPECTED_DIR="modules"


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi


LOG_HEADER "Add new blank module"


current_dir="$(pwd)"
current_dir="${current_dir##*/}"
readonly current_dir
if [ "$current_dir" != "$EXPECTED_DIR" ]; then
  LOG_ERROR "The current directory is expected to be $Y$EXPECTED_DIR$D ... Instead detected $Y$current_dir$D"
  LOG_ERROR "exit" && exit 8
fi

LOG_INFO "Copy Antora template"
cp -a "$1/assets/antora-modules/blank-module" "blank-module"

LOG_WARN "TODO: Rename the module"
LOG_WARN "TODO: Update the nav.adoc according to your needs"
LOG_WARN "TODO: Update the headline in pages/index.adoc"
LOG_WARN "TODO: Add module to antora.yml"
