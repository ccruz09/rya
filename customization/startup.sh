#!/bin/bash

# Usage: startup.sh
#

set -eux

JBOSS_HOME=/opt/jboss/wildfly
XMLSTARLET_CMD=/usr/bin/xmlstarlet

STANDALONE_XML=$JBOSS_HOME/standalone/configuration/standalone.xml

env

sed -i "s/instance\.zk=.*/instance\.zk=$ACCUMULO_PORT_2181_TCP_ADDR:$ACCUMULO_PORT_2181_TCP_PORT/" /opt/jboss/wildfly/modules/accumulo/configuration/main/environment.properties

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -c standalone.xml

