#!/bin/bash
# @file jarvis.sh
# @brief Entrypoint to the jarvis bash utility.
#
# @description The script is the entrypoint to the jarvis bash utility. The scripts provides a select menu
# to choose which module to run.
#
# Something about /opt/jarvis
#
# === Script Arguments
#
# The script does not accept any parameters.
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


docker run --rm mwendler/figlet:latest 'Jarvis CLI'
echo -e "$LOG_INFO Current workdir = $(pwd)"
echo -e "$LOG_INFO What do you want me to do?"
select module in modules/*; do
  echo -e "$LOG_INFO Run $P$module$D"
  bash "$module/module.sh" "$module"
  break
done
