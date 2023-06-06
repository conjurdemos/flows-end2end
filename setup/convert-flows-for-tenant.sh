#!/bin/bash

# Converts Flow template json files for use in specified tenants.
# Changes all generic placeholders in files in FLOW_TEMPLATES_DIR
# to corresponding DEST_* values and writes files to FLOWS_FOR_IMPORTING_DIR.

# Local directories for Flows json files
export FLOW_TEMPLATES_DIR=flow-templates
export FLOWS_FOR_IMPORTING_DIR=flows-for-import

# Hostname values in target tenant(s). The tenant hosting Flows 
# can be the same or different from the tenant hosting Privcloud and Conjur.
# But the ISPSS tenant must have an Oauth2 confidential client with Admin roles
# for both PrivCloud and Conjur Cloud.
export DEST_FLOWS_HOSTNAME=aao4987.flows.cyberark.cloud
export DEST_ISPSS_HOSTNAME=aao4987.id.cyberark.cloud
export DEST_PCLOUD_HOSTNAME=cybr-secrets.privilegecloud.cyberark.cloud
export DEST_CONJUR_HOSTNAME=cybr-secrets.secretsmgr.cyberark.cloud/api

mkdir -p ./$FLOWS_FOR_IMPORTING_DIR
rm ./$FLOWS_FOR_IMPORTING_DIR/*
pushd $FLOW_TEMPLATES_DIR
for i in $(ls); do
  cat $i							\
  | sed -e "s#{{ FLOWS_HOSTNAME }}#$DEST_FLOWS_HOSTNAME#g"	\
  | sed -e "s#{{ ISPSS_HOSTNAME }}#$DEST_ISPSS_HOSTNAME#g"	\
  | sed -e "s#{{ PCLOUD_HOSTNAME }}#$DEST_PCLOUD_HOSTNAME#g"	\
  | sed -e "s#{{ CONJUR_HOSTNAME }}#$DEST_CONJUR_HOSTNAME#g"	\
  > ../$FLOWS_FOR_IMPORTING_DIR/$i
done

echo
echo
echo "Flow json files in $FLOWS_FOR_IMPORTING_DIR are ready for importing"
echo " into the $DEST_FLOWS_HOSTNAME tenant."
echo
echo
