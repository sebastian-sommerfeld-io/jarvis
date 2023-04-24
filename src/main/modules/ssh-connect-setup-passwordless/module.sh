#!/bin/bash
# @file module.sh
# @brief Jarvis module to setup a password-less SSH connection to a remote machine.
#
# @description The module setups a password-less SSH connection to a remote machine using SSH keys.
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

LOG_HEADER "Setup password-less ssh connection to a remote machine"

LOG_INFO "Enter remote username"
read -r REMOTE_USER
readonly REMOTE_USER

LOG_INFO "Enter remote host (Hostname, FQDN or IP)"
read -r REMOTE_HOST
readonly REMOTE_HOST

LOG_INFO "Copy the public key for $REMOTE_USER to $REMOTE_HOST"
ssh-copy-id "$REMOTE_USER@$REMOTE_HOST"
