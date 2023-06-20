#!/bin/bash
# @file module.sh
# @brief Jarvis module to connect to a remote machine via SSH.
#
# @description The module connects to a remote machine via SSH.
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


readonly OPTION_HOMELAB="homelab"


# @description Choose a remote host on the homelab to connect via SSH.
#
# @example
#    ssh_homelab
function ssh_homelab() {
  readonly FQDN_SUFFIX="fritz.box"
  readonly REMOTE_USER="sebastian"
  readonly REMOTE_HOST_CAPRICA="caprica.$FQDN_SUFFIX"
  readonly REMOTE_HOST_KOBOL="kobol.$FQDN_SUFFIX"
  readonly REMOTE_HOST_MONITORING="monitoring.$FQDN_SUFFIX"
  readonly REMOTE_HOST_SUPERVISOR="supervisor.$FQDN_SUFFIX"
  readonly REMOTE_HOST_OPENAPPSEC="openappsec.$FQDN_SUFFIX"

  local host=""

  LOG_INFO "Select host"  
  select h in "$REMOTE_HOST_CAPRICA" "$REMOTE_HOST_KOBOL" "$REMOTE_HOST_MONITORING" "$REMOTE_HOST_SUPERVISOR" "$REMOTE_HOST_OPENAPPSEC"; do
    host="$h"
    break
  done

  LOG_INFO "Connect"
  ssh "$REMOTE_USER@$host"
}


LOG_HEADER "SSH Connect"

LOG_INFO "Choose the environment"
select e in "$OPTION_HOMELAB"; do
  case "$e" in
  "$OPTION_HOMELAB" ) ssh_homelab ;;
  esac
  break
done
