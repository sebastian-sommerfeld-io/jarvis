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


IS_DEV="false"
if [ "$0" != "/usr/bin/jarvis" ]; then
  IS_DEV="true"
fi

MODULES_PATH=""
if [ "$0" = "/usr/bin/jarvis" ]; then
  MODULES_PATH="/opt/jarvis/src/main/"
fi
readonly MODULES_PATH


docker run --rm mwendler/figlet:latest 'Jarvis CLI'


(
  if [ "$IS_DEV" = "true" ]; then
    cd ../../ || exit
    echo -e "$LOG_WARN ${Y}Running from local development project${D}"
  else
    cd /opt/jarvis || exit
  fi

  JARVIS_VERSION=$(docker run --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    mikefarah/yq:latest eval ".version" docs/antora.yml)
  
  echo -e "$LOG_INFO ======================================================================================================="
  echo -e "$LOG_INFO Jarvis version   =  $P$JARVIS_VERSION$D (branch / tag)"
)

echo -e "$LOG_INFO Current workdir  =  $(pwd)"
echo -e "$LOG_INFO ======================================================================================================="

echo -e "$LOG_INFO ${Y}What do you want me to do?${D}"
select module in "$MODULES_PATH"modules/*; do
  echo -e "$LOG_INFO Run $P$module$D"

  IS_DEV="$IS_DEV" bash "$module/module.sh" "$module"
  
  break
done
