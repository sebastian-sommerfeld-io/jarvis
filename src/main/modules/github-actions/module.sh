#!/bin/bash
# @file module.sh
# @brief Jarvis module to create default (static) github actions.
#
# @description The module creates default github actions and issue templates. Make sure to run this
# command from the ``.github`` folder in your project. The module only creates static workflows which
# are exactly the same for all repositories.
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


readonly DIR=".github"


if [ -z "$1" ]; then
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi


echo -e "$LOG_INFO ======================================================================================================="
echo -e "$LOG_INFO Add default github action workflows"
echo -e "$LOG_INFO Current workdir = $(pwd)"
if [ "$IS_DEV" = "true" ]; then
  echo -e "$LOG_WARN ${Y}Running from local development project${D}"
fi
echo -e "$LOG_INFO ======================================================================================================="


current_dir="$(pwd)"
current_dir="${current_dir##*/}"
readonly current_dir
if [ "$current_dir" != "$DIR" ]; then
  echo -e "$LOG_ERROR The current directory is expected to be $Y$DIR$D ... Instead detected $Y$current_dir$D"
  echo -e "$LOG_ERROR exit" && exit 8
fi

echo -e "$LOG_INFO Copy pull request template"
cp "$1/assets/PULL_REQUEST_TEMPLATE.md" "PULL_REQUEST_TEMPLATE.md"

echo -e "$LOG_INFO Create workflows folder if not already presend"
mkdir -p workflows

(
  cd workflows || exit

  echo -e "$LOG_INFO Setup workflows and workflow assets"
  cp -a "$1/assets/workflows/assets" ./
  cp "$1/assets/workflows/organize-auto-close-issues.yml" "organize-auto-close-issues.yml"
  cp "$1/assets/workflows/organize-labels.yml" "organize-labels.yml"
  cp "$1/assets/workflows/organize-assign-issues.yml" "organize-assign-issues.yml"
  cp "$1/assets/workflows/organize-dependabot.yml" "organize-dependabot.yml"
  cp "$1/assets/workflows/auto-generate-docs.yml" "auto-generate-docs.yml"
)

echo -e "$LOG_INFO Copy Dependabot config"
cp "$1/assets/dependabot.yml" "dependabot.yml"
echo -e "$LOG_WARN ${Y}There are some manual todos left${D}"
echo -e "$LOG_WARN   - Update Dependabot config according to your needs!"
echo -e "$LOG_WARN   - If needed: Update triggers and if-conditions of your existing pipelines!"
echo -e "$LOG_WARN   - Replace '__COMPONENT_TITLE__' in auto-generate-docs.yml"
