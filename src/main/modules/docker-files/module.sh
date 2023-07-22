#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new Dockerfile or docker-compose,yml.
#
# @description The module creates a new Dockerfile or docker-compose,yml with basic structure
# and docs prepared.
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


readonly OPTION_NEW_DOCKERFILE="Dockerfile"
readonly OPTION_NEW_COMPOSE_FILE="docker-compose.yml"


# @description Create a new Dockerfile.
#
# @arg $1 string The path from jarvis.sh to this module (``modules/<MODULE_NAME>``)
# @arg $2 string The file temlate to use to create a new file (either ``Dockerfile`` or ``docker-compose.yml``)
#
# @exitcode 8 If path from jarvis.sh to this module is missing
# @exitcode 7 If file template is missing
# @exitcode 4 If a file of the same name already exists in the current directory
#
# @example
#    newScript
function newFile() {
  if [ -z "$1" ]; then
    LOG_ERROR "Param missing: module path"
    LOG_ERROR "exit" && exit 8
  fi
  if [ -z "$2" ]; then
    LOG_ERROR "Param missing: file template"
    LOG_ERROR "exit" && exit 7
  fi

  readonly FILENAME="$2"
  LOG_INFO "Create new $FILENAME"

  if [ -f "$FILENAME" ]; then
    LOG_ERROR "File $FILENAME already existing"
    LOG_ERROR "exit" && exit 4
  fi

  cp "$1/assets/$FILENAME" "$FILENAME"
  LOG_DONE "Created $FILENAME"
}


LOG_HEADER "Docker file actions"
LOG_INFO "Choose which file to create"
select e in "$OPTION_NEW_DOCKERFILE" "$OPTION_NEW_COMPOSE_FILE"; do
  case "$e" in
  "$OPTION_NEW_DOCKERFILE" ) newFile "$1" "Dockerfile" ;;
  "$OPTION_NEW_COMPOSE_FILE" ) newFile "$1" "docker-compose.yml" ;;
  esac
  break
done
