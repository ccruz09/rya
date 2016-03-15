#!/bin/bash

###
# #%L
# SAPPHIRE Services
# %%
# Copyright (C) 2015 Harmonia Holdings Group, LLC
# %%
# This software is being made available to the Government of the United States
# of America with unlimited rights.
# -
# The U.S. Government may use, modify, reproduce, perform, display, release, or
# disclose information, in whole or in part, in any manner and for any purpose
# whatsoever and request or authorize others to do so.
# #L%
###

# Usage: execute.sh [WildFly mode] [configuration file]
#
# The default mode is 'standalone' and default configuration is based on the
# mode. It can be 'standalone.xml' or 'domain.xml'.

set -eux

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

env

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG > /dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
$JBOSS_CLI -c --file=`dirname "$0"`/commands.cli

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

mv /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/$(date +"%Y%m%d-%s")