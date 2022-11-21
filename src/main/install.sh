#!/bin/bash
# @file install.sh
# @brief Install jarvis to ``/opt/jarvis`` and make executable via ``/usr/bin/jarvis``.
#
# @description The script installs jarvis to ``/opt/jarvis`` and makes jarvis executable via ``/usr/bin/jarvis``.
# All jarvis assets are cloned from Github during the installation. To update
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


TEMP_PATH="/tmp/jarvis"
REPO_PATH="/opt/jarvis"
BIN="/usr/bin/jarvis"


echo -e "$LOG_INFO Run preparations"
sudo rm -rf "$TEMP_PATH"
sudo rm -rf "$REPO_PATH"
sudo rm -rf "$BIN"


echo -e "$LOG_INFO Clone Jarvis Repository"
git clone https://github.com/sebastian-sommerfeld-io/jarvis.git "$TEMP_PATH"
sudo mv "$TEMP_PATH" "$REPO_PATH"

echo -e "$LOG_INFO Clone Jarvis Repository"
sudo ln -s "$REPO_PATH/src/main/jarvis.sh" "$BIN"
chmod +x "$BIN"

echo -e "$LOG_INFO Jarvis setup complete"
