#!/bin/bash
# @file module.sh
# @brief Jarvis module to create Github Actions workflows for housekeeping purposes.
#
# @description The module creates Github Actions workflows for housekeeping purposes.
#
# * housekeeping-issues.yml
# * housekeeping-labels.yml
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
readonly PLACEHOLDER_PROJECT_URL="__PROJECT_URL__"
PROJECT_URL="https://github.com/orgs/sommerfeld-io/projects/1"

LOG_HEADER "Create Github Actions workflows for housekeeping purposes"


current_dir="$(pwd)"
current_dir="${current_dir##*/}"
readonly current_dir
if [ "$current_dir" != "$EXPECTED_DIR" ]; then
  LOG_ERROR "The current directory is expected to be $Y$EXPECTED_DIR$D ... Instead detected $Y$current_dir$D"
  LOG_ERROR "exit" && exit 8
fi


cp "$1/assets/workflows/housekeeping-issues-tftpl.yml" "workflows/housekeeping-issues.yml"
sed -i "s|$PLACEHOLDER_PROJECT_URL|$PROJECT_URL|g" "workflows/housekeeping-issues.yml"

cp "$1/assets/workflows/housekeeping-issues-labels.yml" "workflows/housekeeping-labels.yml"

cp "$1/assets/templates/risk-or-technical-debt.md" "ISSUE_TEMPLATE/risk-or-technical-debt.md"
cp "$1/assets/templates/user-story.md" "ISSUE_TEMPLATE/user-story.md"

cp "$1/assets/templates/PULL_REQUEST_TEMPLATE.md" "PULL_REQUEST_TEMPLATE.md"

LOG_DONE "Created $FILENAME"
