#!/bin/bash
# @file module.sh
# @brief Zora module to add files and commit files to git repo.
#
# @description The command prompts for a Jira Issue Key and then prompts for a commit message. The command validates
# the syntax of the Jira Issue Key and then concatenates these inputs into a single commit message. Then ``git add *``
# and ``git commit -m "<THE_MESSAGE>"`` is run.
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
# ./module.sh
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

LOG_INFO "Enter Jira Issue Key"
read -r ISSUE_KEY
readonly ISSUE_KEY

LOG_INFO "Enter Commit Message"
read -r COMMIT_MESSAGE
readonly COMMIT_MESSAGE

LOG_INFO "Git add"
git add *

LOG_INFO "Git commit"
git commit -m "$ISSUE_KEY $COMMIT_MESSAGE"
