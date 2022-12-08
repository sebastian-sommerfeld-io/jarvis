#!/bin/bash
# @file module.sh
# @brief Jarvis module to set up repos and configs on Github using the Github CLI.
#
# @description The module allows configuration of link:https://www.github.com[Github] repos, settings,
# etc. (e.g. creating secrets for repositories) using the link:https://cli.github.com/manual[Github CLI].
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


MODULE_PATH="$1"
DOCKER_IMAGE="local/github-cli:dev"
GITHUB_TOKEN=$(cat "$MODULE_PATH/.secrets/github.token")


# @description Facade to map ``gh`` command to the local docker container. The actual github-cli
# execution is delegated to a Docker container.
#
# @example
#    gh --version
#
# @arg $@ String The ``gh`` commands (1-n arguments) - $1 is mandatory
#
## @exitcode 8 If param with ``gh`` commands is missing
function gh() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  docker run --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --env "GITHUB_TOKEN=$GITHUB_TOKEN" \
    "$DOCKER_IMAGE" gh "$@"
}


# @description Run all setup tasks and take care of all prerequisites and dependencies. This function
# builds the local Docker image (among other things).
#
# @example
#    setUp
function setUp() {
  echo -e "$LOG_INFO Set up"
  (
    cd "$MODULE_PATH" || exit

    echo -e "$LOG_INFO Build local Docker image $DOCKER_IMAGE"
    docker build --no-cache -t "$DOCKER_IMAGE" .
  )
}


# @description Run all cleanup tasks at the end of the script.
#
# @example
#    tearDown
function tearDown() {
  echo -e "$LOG_INFO Tear down"
  
  echo -e "$LOG_INFO Remove local Docker image $DOCKER_IMAGE"
  docker image rm "$DOCKER_IMAGE"
}


echo -e "$LOG_INFO Github CLI options"
echo -e "$LOG_INFO Current workcurrent_dir = $(pwd)"

setUp

echo -e "$LOG_INFO Show Github CLI version"
echo -e "$LOG_INFO ======================================================================================================="
gh --version
echo -e "$LOG_INFO ======================================================================================================="

# todo select menu for options "secrets repo-list whatever"

echo -e "$LOG_INFO Create new secret"
gh secret set FROM_GITHUB_CLI_IN_JARVIS --body "some stuff from jarvis" --repo "sebastian-sommerfeld-io/jarvis"

echo -e "$LOG_INFO List actions secrets"
gh secret list --app "actions" --repo "sebastian-sommerfeld-io/jarvis"

tearDown
