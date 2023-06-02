#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a basic Github Actions workflows and Dependabot config.
#
# @description The module creates basic Github Actions workflows and Dependabot config.
# The generated files are:
#
# * ``.github/workflows/ci.yml`` -> Basic CI workflow which runs some linters. Linter definitions are not created by this module.
# * ``.github/dependabot.yml`` -> Keeps your dependencies updated. Version updates regularly update all the packages used by your repository, even if they don't have any known vulnerabilities. To enable version updates, check a ``dependabot.yml`` configuration file into your repository.
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
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi


readonly EXPECTED_DIR=".github"


LOG_HEADER "Create basic Github Actions workflows and Dependabot config"


current_dir="$(pwd)"
current_dir="${current_dir##*/}"
readonly current_dir
if [ "$current_dir" != "$EXPECTED_DIR" ]; then
  LOG_ERROR "The current directory is expected to be $Y$EXPECTED_DIR$D ... Instead detected $Y$current_dir$D"
  LOG_ERROR "exit" && exit 8
fi


cp "$1/assets/workflows/ci.yml" "workflows/ci.yml"
cp "$1/assets/workflows/docs-as-code.yml" "workflows/docs-as-code.yml"
cp "$1/assets/dependabot.yml" "dependabot.yml"

LOG_WARN "TODO: Add linter definitions to use with $EXPECTED_DIR/workflows/ci.yml"
