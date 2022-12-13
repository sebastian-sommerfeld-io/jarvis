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


readonly MODULE_PATH="$1"
readonly DOCKER_IMAGE="local/github-cli:dev"
readonly TEST_REPO="sebastian-sommerfeld-io/trashbox"


readonly TOKEN_FILE="$MODULE_PATH/.secrets/github.token"
if [ ! -f "$TOKEN_FILE" ]; then
  echo -e "$LOG_WARN No github peronal access token found"
  echo -e "$LOG_WARN See Bitwarden Vault for token value (if exists)"
  echo -e "$LOG_WARN Manage tokens in Github: https://github.com/settings/tokens"
  echo -e "$LOG_INFO Enter token"
  read -r token
  echo "$token" > "$TOKEN_FILE"
fi
GITHUB_TOKEN=$(cat "$TOKEN_FILE")
readonly GITHUB_TOKEN


readonly MENU_OPTION_SECRETS="add_secrets"
readonly MENU_OPTION_DEPENDABOT_PR="list_dependabot_pull_requests"


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
  local secret_GOOGLE_CHAT_WEBHOOK="GOOGLE_CHAT_WEBHOOK"
  local secret_GH_TOKEN_REPO_AND_PROJECT="GH_TOKEN_REPO_AND_PROJECT"
  local secret_DOCKERHUB_USER="DOCKERHUB_USER"
  local secret_DOCKERHUB_PASS="DOCKERHUB_PASS"
  local secret_SNYK_TOKEN="SNYK_TOKEN"
  local secret_FTP_USER="FTP_USER"
  local secret_FTP_PASS="FTP_PASS"

  echo -e "$LOG_INFO Create secrets"

  echo -e '\033[0;37m' # light grey
  cat "$MODULE_PATH/assets/help/secrets.txt"
  echo -e "$D"

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


# @description Function to handle to list all Pull Requests from Dependabot and all unassigned
# Pull Requests from Dependabot. Affected Pull Requests are labeled 'dependencies' automatically by
# Dependabot.
#
# @example
#    listDependabotPRs
function listDependabotPRs() {
  local dependabotLabel="dependencies"

  echo -e "$LOG_INFO List ${P}all open${D} Pull Requests from dependabot"
  gh pr list --label "$dependabotLabel"

  echo -e "$LOG_INFO List ${P}open and unassinged ${D} Pull Requests from dependabot"
  gh pr list --search "no:assignee label:$dependabotLabel"
}


echo -e "$LOG_INFO Github CLI options"
echo -e "$LOG_INFO Current workcurrent_dir = $(pwd)"

setUp

echo -e "$LOG_INFO Show Github CLI version"
echo -e "$LOG_INFO ======================================================================================================="
echo "Github CLI"
gh --version
if [ "$IS_DEV" = "true" ]; then
  echo -e "$LOG_WARN ${Y}Running from local development project${D}"
  echo -e "$LOG_WARN Using repo: ${Y}$TEST_REPO${D}"
fi
echo -e "$LOG_INFO ======================================================================================================="

echo -e "$LOG_INFO ${Y}Github CLI - Menu${D}"
select option in "$MENU_OPTION_SECRETS" "$MENU_OPTION_DEPENDABOT_PR"; do
  case "$option" in
    "$MENU_OPTION_SECRETS" ) secrets ;;
    "$MENU_OPTION_DEPENDABOT_PR" ) listDependabotPRs ;;
  esac

  break
done

tearDown
