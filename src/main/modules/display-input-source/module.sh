#!/bin/bash
# @file module.sh
# @brief Jarvis module to push files to a remote git repo.
#
# @description This script switches the display inputs for my Dell monitors to
# avoid having to use the monitors physical buttons.
#
# The script is designed to only work on the ``caprica`` host and fails if
# another machine runs this script.
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


LOG_INFO "Display Input Source"


readonly ALLOWED_HOST="caprica"
readonly TARGET_CAPRICA="caprica"
readonly TARGET_WORK="provinzial"


if [[ ! "$HOSTNAME" == "$ALLOWED_HOST" ]]; then
  echo -e "$LOG_ERROR Script is only allowed to run on host '$ALLOWED_HOST'"
  echo -e "$LOG_ERROR exit" && exit 8
fi


select TARGET in "$TARGET_CAPRICA" "$TARGET_WORK"; do

  readonly MONITOR_LEFT="5" # Curved (landscape) /dev/i2c-5
  readonly MONITOR_RIGHT="4" # UHD (portrait) /dev/i2c-4

  readonly CHANGE_INPUT_SOURCE="0x60"
  readonly SOURCE_HDMI_1="0x11"
  readonly SOURCE_HDMI_2="0x12"
  readonly SOURCE_DP="0x0f"

  case "$TARGET" in
    "$TARGET_CAPRICA")
      ddcutil -b "$MONITOR_LEFT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_DP"
      ddcutil -b "$MONITOR_RIGHT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_1"
    ;;
    "$TARGET_WORK")
      ddcutil -b "$MONITOR_LEFT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_2"
      ddcutil -b "$MONITOR_RIGHT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_2"
    ;;
    *)
      echo -e "$LOG_ERROR No valid workstation passed"
      echo -e "$LOG_ERROR Allowed values are '$ALLOWED_HOST' and 'provinzial'"
      echo -e "$LOG_ERROR exit" && exit 8
    ;;
  esac

  break
done
