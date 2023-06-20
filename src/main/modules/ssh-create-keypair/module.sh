#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new ssh keypair.
#
# @description The module creates a new ssh keypair and write the keypair in the current users ``~.ssh`` folder.
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


readonly ALGORITHM="rsa"
readonly KEY_SIZE="4096"


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi



LOG_HEADER "Create ssh keypair"


LOG_INFO "Enter filename"
read -r FILENAME
readonly FILENAME

(
  cd "$HOME/.ssh" || exit

  if [ -f "$FILENAME" ]; then
    LOG_ERROR "File $FILENAME already existing"
    LOG_ERROR "exit" && exit 4
  fi

  LOG_INFO "Create new ssh key-pair: $FILENAME"
  LOG_INFO "  Algorithm = $ALGORITHM"
  LOG_INFO "   Key size = $KEY_SIZE"
  ssh-keygen -f "$FILENAME" -t "$ALGORITHM" -b "$KEY_SIZE" -C "sebastian@sommerfeld.io"
)

LOG_DONE "Created $FILENAME and $FILENAME.pub"
