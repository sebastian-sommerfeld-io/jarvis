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


# @description Log message with log level = DONE.
#
# @arg $@ String The line to print.
function LOG_DONE() {
  local LOG_DONE="[\e[32mDONE\e[0m]"
  echo -e "$LOG_DONE $1"
}


# @description Log message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  local LOG_ERROR="[\e[1;31mERROR\e[0m]" 
  echo -e "$LOG_ERROR $1"
}


# @description Log message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  local LOG_INFO="[\e[34mINFO\e[0m]"
  echo -e "$LOG_INFO $1"
}


# @description Log message with log level = WARN.
#
# @arg $@ String The line to print.
function LOG_WARN() {
  local LOG_WARN="[\e[93mWARN\e[0m]"
  echo -e "$LOG_WARN $1"
}


# @description Print log output in a header-style.
#
# @arg $@ String The line to print.
function LOG_HEADER() {
  LOG_INFO "------------------------------------------------------------------------------------"
  LOG_INFO "$1"
  LOG_INFO "------------------------------------------------------------------------------------"
}


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi


LOG_INFO "Enter Jira issue key"
read -r ISSUE_KEY
readonly ISSUE_KEY

ISSUE_KEY_REGEX='\b[A-Z][A-Z0-9_]+-[1-9][0-9]*'
if [[ ! "$ISSUE_KEY" =~ $ISSUE_KEY_REGEX ]]; then
  LOG_ERROR "Jira issue key not valid (wrong syntax)"
  LOG_ERROR "exit" && exit 8
fi

LOG_INFO "Enter commit message"
read -r COMMIT_MESSAGE
readonly COMMIT_MESSAGE

LOG_INFO "Run git add"
git add ./*

LOG_INFO "Run git commit"
git commit -m "$ISSUE_KEY $COMMIT_MESSAGE"
