#!/bin/bash
# Needs DEIS_CONTROLLER URL, DEIS_USERNAME, DEIS_PASSWORD,
# DOCKER_REPOSITORY and DEIS_APPLICATION environment variables.
#
# To set them go to Job -> Configure -> Build Environment -> Inject
# passwords and Inject env variables
#

set -ex

# Create a temporary virtualenv to install deis client
TDIR=`mktemp -d`
virtualenv $TDIR
. $TDIR/bin/activate
pip install deis==1.6.1


deis login $DEIS_CONTROLLER  --username $DEIS_USERNAME --password $DEIS_PASSWORD
deis scale cmd=1 -a $DEIS_APPLICATION
deis pull $DOCKER_REPOSITORY:`git rev-parse HEAD` -a $DEIS_APPLICATION
deis scale cmd=${NUMBER_OF_INSTANCES:-3} -a $DEIS_APPLICATION
