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
TEST_REPO="sebastian-sommerfeld-io/trashbox"

MENU_OPTION_SECRETS="secrets"


# @description Facade to map ``gh`` command to the local docker container. The actual github-cli
# execution is delegated to a Docker container. When running this script during local development,
# all commands are executed against the ``sebastian-sommerfeld-io/trashbox`` repository.
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

  if [ "$1" = "--version" ]; then
    docker run --rm "$DOCKER_IMAGE" gh "$@"
  else
    if [ "$IS_DEV" = "true" ]; then
      echo -e "$LOG_WARN ${Y}Running from local development project${D}"
      echo -e "$LOG_WARN Using repo: ${Y}$TEST_REPO${D}"
      docker run --rm \
        --volume /etc/passwd:/etc/passwd:ro \
        --volume /etc/group:/etc/group:ro \
        --user "$(id -u):$(id -g)" \
        --volume /etc/timezone:/etc/timezone:ro \
        --volume /etc/localtime:/etc/localtime:ro \
        --volume "$(pwd):$(pwd)" \
        --workdir "$(pwd)" \
        --env "GITHUB_TOKEN=$GITHUB_TOKEN" \
        "$DOCKER_IMAGE" gh "$@" --repo "$TEST_REPO"
    else
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
    fi
  fi
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


# @description Function to handle all tasks for menu option "secrets". Creates secrets for a given
# github repository.
#
# @example
#    secrets
function secrets() {
  secret_GOOGLE_CHAT_WEBHOOK="GOOGLE_CHAT_WEBHOOK"
  secret_GH_TOKEN_REPO_AND_PROJECT="GH_TOKEN_REPO_AND_PROJECT"
  secret_DOCKERHUB_USER="DOCKERHUB_USER"
  secret_DOCKERHUB_PASS="DOCKERHUB_PASS"
  secret_SNYK_TOKEN="SNYK_TOKEN"
  secret_FTP_USER="FTP_USER"
  secret_FTP_PASS="FTP_PASS"

  echo -e "$LOG_INFO Secrets for all repositories"
  echo -e "$LOG_INFO   ${P}$secret_GH_TOKEN_REPO_AND_PROJECT${D}  ...  Pipeline interacts with Github Projects"
  echo -e "$LOG_INFO   ${P}$secret_GOOGLE_CHAT_WEBHOOK${D}  .........  Pipeline sends error messages to chat"
  echo -e "$LOG_INFO Secrets for repositories with Docker images"
  echo -e "$LOG_INFO   ${P}$secret_DOCKERHUB_USER${D}  ..............  Deploy container image to DockerHub"
  echo -e "$LOG_INFO   ${P}$secret_DOCKERHUB_PASS${D}  ..............  Deploy container image to DockerHub"
  echo -e "$LOG_INFO   ${P}$secret_SNYK_TOKEN${D}  ..................  Scan container image for security issues"
  echo -e "$LOG_INFO Secrets for repositories with HTML websites"
  echo -e "$LOG_INFO   ${P}$secret_FTP_USER${D}  ....................  Upload html contents to ftp webspace"
  echo -e "$LOG_INFO   ${P}$secret_FTP_PASS${D}  ....................  Upload html contents to ftp webspace"

  echo -e "$LOG_INFO ${Y}Which secret should I create?${D}"
  select s in "$secret_GOOGLE_CHAT_WEBHOOK" "$secret_GH_TOKEN_REPO_AND_PROJECT" "$secret_DOCKERHUB_USER" "$secret_DOCKERHUB_PASS" "$secret_SNYK_TOKEN" "$secret_FTP_USER" "$secret_FTP_PASS"; do
    echo -e "$LOG_INFO Create new secret $s"
    echo -e "$LOG_INFO Enter value for secret"
    read -r value

    gh secret set "$s" --body "$value"
    break
  done

  echo -e "$LOG_INFO List all secrets from repository"
  gh secret list --app "actions"
}


echo -e "$LOG_INFO Github CLI options"
echo -e "$LOG_INFO Current workcurrent_dir = $(pwd)"

setUp

echo -e "$LOG_INFO Show Github CLI version"
echo -e "$LOG_INFO ======================================================================================================="
echo "Github CLI"
gh --version
echo -e "$LOG_INFO ======================================================================================================="

echo -e "$LOG_INFO ${Y}Github CLI - Menu${D}"
select option in "$MENU_OPTION_SECRETS"; do
  case "$option" in
    "$MENU_OPTION_SECRETS" ) secrets ;;
  esac

  break
done

tearDown
