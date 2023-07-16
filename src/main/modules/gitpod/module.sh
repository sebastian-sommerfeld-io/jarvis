#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a pre-defined Gitpod configuration.
#
# @description The Jarvis module streamlines the setup process by automatically initializing a ``.gitpod.yml``
# file with essential configurations. Additionally, it manages the installation of Visual Studio Code (VSCode)
# extensions, ensuring a consistent and efficient development environment. By utilizing the Jarvis module,
# developers can quickly set up their Gitpod workspace with the necessary configurations and extensions,
# enabling a seamless and productive coding experience.
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


LOG_HEADER "Create .gitpod.yml"
cp "$1/assets/.gitpod.yml" ".gitpod.yml"
