#!/bin/bash
# @file install.sh
# @brief Install jarvis to ``/opt/jarvis`` and make executable via ``/usr/bin/jarvis``.
#
# @description The script installs jarvis to ``/opt/jarvis`` and makes jarvis executable via
# ``/usr/bin/jarvis``. All jarvis assets are cloned from Github during the installation. To update the
# installation, just run this script again.
#
# CAUTION: Be aware that running this script might result in conflicts with other (unrelated) software
# packages of the same name because /usr/bin/jarvis might belong to something else.
#
# NOTE: ``$LOG_INFO`` and ``$LOG_DONE`` are declared inside this script to be available in all Linux
# environments, not just when present in a users ``.bashrc`` file. Without these variable declarations
# the script fails with error message ``unbound variable`` due to the ``set -o nounset`` directive.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./install.sh
# # or
# curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/install.sh | bash -
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



readonly TEMP_PATH="/tmp/jarvis"
readonly REPO_PATH="/opt/jarvis"
readonly BIN="/usr/bin/jarvis"


LOG_INFO "Run preparations"
sudo rm -rf "$TEMP_PATH"
sudo rm -rf "$REPO_PATH"
sudo rm -rf "$BIN"


LOG_INFO "Clone Jarvis Repository"
git clone https://github.com/sebastian-sommerfeld-io/jarvis.git "$TEMP_PATH"
sudo mv "$TEMP_PATH" "$REPO_PATH"

LOG_INFO "Clone Jarvis Repository"
sudo ln -s "$REPO_PATH/src/main/jarvis.sh" "$BIN"
chmod +x "$BIN"

LOG_DONE "Jarvis setup complete"
