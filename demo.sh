#!/bin/bash

#######################################
# Admin user must be an ISPSS Oauth2 confidential client 
# with Privcloud and Conjur cloud admin roles
export ADMIN_USER=
export ADMIN_PWD=

# Tenant hosting flows
export FLOWS_TENANT=

# Email address to send confirmation emails
export REQUESTOR=
#######################################

# Name for both CCP AppID and Conjur host workload ID
export APP_ID=e2etest

# Name for Safe to create - OK if it already exists
export SAFE_NAME=End2EndFlowsTest

# Propery values for new ssh-key Safe account
export SSH_ACCOUNT_NAME=E2E-SSH
export SSH_KEY_FILE=./ssh-key-for-demo.pem
export SSH_PKEY="$(cat $SSH_KEY_FILE | base64)"
export SSH_USER=ubuntu
export SSH_ADDRESS=192.168.99.1

######################################################
######################################################
#
#  Dont change anything below this line
#
######################################################
######################################################

if [[ $# != 1 ]]; then
  echo
  echo "Select 1 or 2)"
  echo "  1) Provision"
  echo "  2) Deprovision"
  echo
  read option
else
  option=$1
fi

case $option in
  1 | p | P) export FLOW_NAME=End2End-Provision
     ;;
  2 | d | D) export FLOW_NAME=End2End-Deprovision
     ;;
  *) echo "Invalid selection, exiting..."
     exit -1
     ;;
esac

echo
echo "Running:"
echo "  Tenant: $FLOWS_TENANT"
echo "  Flow: $FLOW_NAME"
echo "  AppID: $APP_ID"
echo "  SafeName: $SAFE_NAME"
echo "  RequestorEmail: $REQUESTOR"
echo "  SshAcctName: $SSH_ACCOUNT_NAME"
echo "  SshUser: $SSH_USER"
echo "  SshPkey: $SSH_PKEY"
echo "  SshAddress: $SSH_ADDRESS"
echo
set -x
curl -k -X POST						\
	-H 'Content-Type: application/json' 		\
	--data "{					\
		\"adminId\": \"$ADMIN_USER\",		\
		\"adminPassword\": \"$ADMIN_PWD\",	\
		\"appId\": \"$APP_ID\",			\
		\"safeName\": \"$SAFE_NAME\",		\
		\"requestorEmail\": \"$REQUESTOR\",	\
		\"sshAcctName\": \"$SSH_ACCOUNT_NAME\",	\
		\"sshUser\": \"$SSH_USER\",		\
		\"sshPkey\": \"$SSH_PKEY\",		\
		\"sshAddress\": \"$SSH_ADDRESS\"	\
	}"						\
	https://$FLOWS_TENANT/flows/$FLOW_NAME/play
echo
echo
