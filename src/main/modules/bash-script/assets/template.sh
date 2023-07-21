#!/bin/bash
# @file __FILENAME__
# @brief Lorem ipsum dolor sit amet, consetetur sadipscing elitr.
#
# @description Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut
# labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
# Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 
#
# === Script Arguments
#
# The script does not accept any parameters.
# * *$1* (string): Some var
#
# === Script Example
#
# [source, bash]
# ```
# ./__FILENAME__
# ```
#
# == Prerequisites
#
# Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore
# magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd
# gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 
#
# == Lorem ipsum dolor
#
# Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore
# magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd
# gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# Download and include logging library
rm -rf /tmp/bash-lib
mkdir -p /tmp/bash-lib
curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh
source /tmp/bash-lib/log.sh


LOG_HEADER "Run $0"
