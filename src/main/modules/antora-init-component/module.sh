#!/bin/bash
# @file jarvis.sh
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
  echo -e "$LOG_ERROR Param missing: module path"
  echo -e "$LOG_ERROR exit" && exit 8
fi

echo -e "$LOG_INFO Enter component title:"
read -r COMPONENT_TITLE

echo -e "$LOG_INFO Enter component name (url slug):"
read -r COMPONENT_NAME

echo -e "$LOG_INFO Enter Github project name (without path)"
read -r GITHUB_PROJECT_NAME


echo -e "$LOG_INFO Create Antora component"
echo -e "$LOG_INFO Current workdir = $(pwd)"

echo -e "$LOG_INFO Copy Antora template"
cp -a "$1/assets/antora-component/docs" "docs"

echo -e "$LOG_INFO Update component name"
old="__COMPONENT_NAME__"
sed -i "s|$old|$COMPONENT_NAME|g" docs/antora.yml

echo -e "$LOG_INFO Update component title"
old="__COMPONENT_TITLE__"
sed -i "s|$old|$COMPONENT_TITLE|g" docs/antora.yml
sed -i "s|$old|$COMPONENT_TITLE|g" docs/modules/ROOT/pages/index.adoc

echo -e "$LOG_INFO Update Github project name"
old="__GITHUB_PROJECT_NAME__"
sed -i "s|$old|$GITHUB_PROJECT_NAME|g" docs/modules/ROOT/partials/vars.adoc

echo -e "$LOG_INFO Create README.adoc"
echo "= $COMPONENT_TITLE" > README.adoc
