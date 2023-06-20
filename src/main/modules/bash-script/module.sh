#!/bin/bash
# @file module.sh
# @brief Jarvis module to handle tasks related to bash scripts.
#
# @description The module handles tasks related to bash scripts.
#
# . Create a new bash script and apply basic config. The script contains basic shdoc comments, some default options like ``set -o nounset`` and marks the scripts as executable. The created script contains a snippet to download and include a bash module which provides logging functionalities.
# . Print the snippet to download and include the bash logging module.
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


readonly OPTION_NEW_SCRIPT="new-script"
readonly OPTION_PRINT_LOGGING_SNIPPET="print-logging-snippet"


# @description Choose a remote host on the homelab to connect via SSH.
#
# @arg $1 string The path from jarvis.sh to this module (``modules/<MODULE_NAME>``)
#
# @example
#    newScript
function newScript() {
  if [ -z "$1" ]; then
    LOG_ERROR "Param missing: module path"
    LOG_ERROR "exit" && exit 8
  fi

  LOG_INFO "Create new bash script"
  read -r -p "Enter filename (with ending): " FILENAME
  readonly FILENAME

  if [ -f "$FILENAME" ]; then
    LOG_ERROR "File $FILENAME already existing"
    LOG_ERROR "exit" && exit 4
  fi

  cp "$1/assets/template.sh" "$FILENAME"
  old="__FILENAME__"
  sed -i "s|$old|$FILENAME|g" "$FILENAME"
  chmod +x "$FILENAME"

  LOG_DONE "Created $FILENAME"
}


# @description Print the snippet to download and include the bash logging module to the console.
# The snippet can be copied and pasted into existing bash scripts.
#
# @example
#    printLogSnippet
function printLogSnippet() {
  LOG_INFO "Print snippet to download and include the bash logging module"
  echo -e "$P"
  echo "# Download and include logging library"
  echo "rm -rf /tmp/bash-lib"
  echo "mkdir -p /tmp/bash-lib"
  echo "curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh"
  echo "source /tmp/bash-lib/log.sh"
  echo -e "$D"
}


LOG_HEADER "Bash script actions"
LOG_INFO "Choose the action"
select e in "$OPTION_NEW_SCRIPT" "$OPTION_PRINT_LOGGING_SNIPPET"; do
  case "$e" in
  "$OPTION_NEW_SCRIPT" ) newScript "$1" ;;
  "$OPTION_PRINT_LOGGING_SNIPPET" ) printLogSnippet ;;
  esac
  break
done
