#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new Antora module.
#
# @description This module facilitates the creation of Asciidoc files with predefined structures,
# empowering developers to swiftly commence content creation. With multiple template options available,
# including blank files and Architecture Decision Records (ADRs), developers can choose the appropriate
# template to suit their needs. Depending on the template selected, the module may also impact the filename
# to adhere to specific patterns, ensuring consistency and organization throughout the documentation.
#
# The Asciidoc files are created in the current directory.
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


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi


readonly MODULE_PATH="$1"

readonly OPTION_BLANK="blank-file"
readonly OPTION_ADR="ADR"


# @description ...
#
# @example
#    createBlankFile
function createBlankFile() {
  if [ -z "$1" ]; then
    LOG_ERROR "Param missing: filename"
    LOG_ERROR "exit" && exit 8
  fi

  copy template-blank.adoc "$1"
}


# @description ...
#
# @example
#    createAdr
function createAdr() {
  if [ -z "$1" ]; then
    LOG_ERROR "Param missing: filename"
    LOG_ERROR "exit" && exit 8
  fi

  copy template-adr.adoc "adr-$(date '+%Y-%m-%d')-$1"
}


# @description ...
#
# @arg $1 string The template that should be copied
# @arg $2 string The filename for the template
#
# @example
#    copy
function copy() {
  if [ -z "$1" ]; then
    LOG_ERROR "Param missing: template"
    LOG_ERROR "exit" && exit 8
  fi
  if [ -z "$2" ]; then
    LOG_ERROR "Param missing: filename"
    LOG_ERROR "exit" && exit 8
  fi

  cp "$MODULE_PATH/assets/$1" "$2"
  LOG_INFO "Created $Y$2$D"
}


LOG_HEADER "Create Asciidoc files"

LOG_INFO "Enter filename (with file ending)"
LOG_INFO "Keep in mind that Asciidoc files name should be 'kebab-case' or 'SCREAMING_SNAKE_CASE'"
read -r -p "Filename: " FILENAME
readonly FILENAME

LOG_INFO "Choose the Asciidoc template"
select e in "$OPTION_BLANK" "$OPTION_ADR"; do
  case "$e" in
  "$OPTION_BLANK" ) createBlankFile "$FILENAME" ;;
  "$OPTION_ADR" ) createAdr "$FILENAME" ;;
  esac
  break
done
