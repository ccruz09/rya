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

# Usage: startup.sh
#

set -eux

JBOSS_HOME=/opt/jboss/wildfly
XMLSTARLET_CMD=/usr/bin/xmlstarlet

STANDALONE_XML=$JBOSS_HOME/standalone/configuration/standalone.xml

env

sed -i "s/instance\.zk=.*/instance\.zk=$HOSTNAME:2181/" /opt/jboss/wildfly/modules/accumulo/configuration/main/environment.properties
$ACCUMULO_SETUP_DIR/init.sh
$ACCUMULO_SETUP_DIR/start-all.sh

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -c standalone.xml

