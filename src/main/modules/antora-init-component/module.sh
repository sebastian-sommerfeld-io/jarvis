#!/bin/bash
# @file module.sh
# @brief Jarvis module to create a new Antora component.
#
# @description The module creates a new Antora component and a README.adoc.
#
# NOTE: Don't run this script directly! Always run the ``jarvis`` command and select the module of choice.
#
# === Script Arguments
#
# * *$1* (string): The path from jarvis.sh to this module (modules/<MODULE_NAME>)
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


LOG_HEADER "Create Antora component"


LOG_INFO "Enter component title:"
read -r COMPONENT_TITLE
readonly COMPONENT_TITLE

LOG_INFO "Enter component name (url slug):"
read -r COMPONENT_NAME
readonly COMPONENT_NAME

LOG_INFO "Enter Github project name (without path, just the name ... drop 'sebastian-sommerfeld-io/')"
read -r GITHUB_PROJECT_NAME
readonly GITHUB_PROJECT_NAME

LOG_INFO "Copy Antora template"
cp -a "$1/assets/antora-component/docs" "docs"

LOG_INFO "Update component name"
old="__COMPONENT_NAME__"
sed -i "s|$old|$COMPONENT_NAME|g" docs/antora.yml

LOG_INFO "Update component title"
old="__COMPONENT_TITLE__"
sed -i "s|$old|$COMPONENT_TITLE|g" docs/antora.yml
sed -i "s|$old|$COMPONENT_TITLE|g" docs/modules/ROOT/pages/index.adoc

LOG_INFO "Update Github project name"
old="__GITHUB_PROJECT_NAME__"
sed -i "s|$old|$GITHUB_PROJECT_NAME|g" docs/modules/ROOT/partials/vars.adoc

LOG_INFO "Create README.adoc"
echo "= $COMPONENT_TITLE" > README.adoc
