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


JARVIS_VERSION=""
MODULES_PATH=""
if [ "$0" = "/usr/bin/jarvis" ]; then
  MODULES_PATH="/opt/jarvis/src/main/"
fi


docker run --rm mwendler/figlet:latest 'Jarvis CLI'


(
  cd ../../ || exit

  JARVIS_VERSION=$(docker run --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    mikefarah/yq:latest eval ".version" docs/antora.yml)
  
  echo -e "$LOG_INFO ======================================================================================================="
  echo -e "$LOG_INFO Jarvis version   =  $P$JARVIS_VERSION$D (branch / tag)"
  echo -e "$LOG_INFO Current workdir  =  $(pwd)"
  echo -e "$LOG_INFO ======================================================================================================="
)

echo -e "$LOG_INFO ${Y}What do you want me to do?${D}"
select module in "$MODULES_PATH"modules/*; do
  echo -e "$LOG_INFO Run $P$module$D"

  bash "$module/module.sh" "$module"
  
  break
done
