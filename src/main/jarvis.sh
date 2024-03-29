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


# Download and include logging library
rm -rf /tmp/bash-lib
mkdir -p /tmp/bash-lib
curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh
source /tmp/bash-lib/log.sh


MODULES_PATH=""
if [ "$0" = "/usr/bin/jarvis" ]; then
  MODULES_PATH="/opt/jarvis/src/main/"
fi
readonly MODULES_PATH


LOG_HEADER "Current workdir = $(pwd)"


LOG_INFO "What do you want me to do?"
select module in "$MODULES_PATH"modules/*; do
  bash "$module/module.sh" "$module"
  break
done
