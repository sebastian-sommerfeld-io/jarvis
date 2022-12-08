#!/bin/bash
# @file module.sh
# @brief Jarvis module to set up repos and configs on Github using the Github CLI.
#
# @description The module allows configuration of link:https://www.github.com[Github] repos, settings,
# etc. (e.g. creating secrets for repositories) using the link:https://cli.github.com/manual[Github CLI].
# The module prompts for valid github credentials.
#
# NOTE: Don't run this script directly! Always run the ``jarvis`` command and select the module of choice.
#
# === Script Arguments
#
# * *$1* (string): The path from jarvis.sh to this module (modules/<MODULE_NAME>)
#
# === Dependencies
#
# This script builds and runs a local Docker image which contains the github-cli. So Docker must be
# installed.
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
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi


DOCKER_IMAGE="local/github-cli:dev"
GITHUB_TOKEN=$(cat "$1/.secrets/github.token")


echo -e "$LOG_INFO Github CLI"
echo -e "$LOG_INFO Current workcurrent_dir = $(pwd)"

(
  cd "$1" || exit

  echo -e "$LOG_INFO Build local Docker image $DOCKER_IMAGE"
  docker build --no-cache -t "$DOCKER_IMAGE" .
)

echo -e "$LOG_INFO Show Github CLI version"
docker run --rm -it "$DOCKER_IMAGE" gh --version

echo -e "$LOG_INFO List actions secrets"
docker run --rm \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --user "$(id -u):$(id -g)" \
  --volume /etc/timezone:/etc/timezone:ro \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  --env "GITHUB_TOKEN=$GITHUB_TOKEN" \
  "$DOCKER_IMAGE" gh secret list --app "actions" --repo "sebastian-sommerfeld-io/jarvis"

echo -e "$LOG_INFO Remove local Docker image $DOCKER_IMAGE"
docker image rm "$DOCKER_IMAGE"
