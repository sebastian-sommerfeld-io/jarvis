#!/bin/bash
# @file module.sh
# @brief Jarvis module to create an iso image from a CD.
#
# @description Create an iso image from a CD. The module expects the CD drive at a specific path
# (``/dev/cdrom``). This matches my home setup on my workstation (``caprica``).
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


readonly CD_DRIVE="/dev/cdrom"


if [ -z "$1" ]; then
  LOG_ERROR "Param missing: module path"
  LOG_ERROR "exit" && exit 8
fi


if [ ! -L "$CD_DRIVE" ] 
then
  LOG_ERROR "CD ROM drive $CD_DRIVE not found"
  LOG_ERROR "exit" && exit 4
fi


LOG_INFO "Create iso image from $CD_DRIVE"

read -r -p "Enter disk name: " DISK_NAME
readonly DISK_NAME

LOG_INFO "Creating iso ..."
sudo dd if="$CD_DRIVE" of="./$DISK_NAME.iso"

LOG_INFO "Update permissions"
sudo chown "$(id -u):$(id -g)" "$DISK_NAME.iso"
sudo chmod +x "$DISK_NAME.iso"
