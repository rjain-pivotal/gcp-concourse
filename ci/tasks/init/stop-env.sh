#!/bin/bash
set -e


if [ $arg_wipe == "stop" ];
        then
                echo "Stopping Environment...."
        else
                echo "Need Args [0]=stop, anything else and I swear I'll exit and do nothing!!! "
                echo "Example: ./stop-env.sh stop ..."
                exit 0
fi


#############################################################
#################### GCP Auth  & functions ##################
#############################################################
echo $gcp_svc_acct_key > /tmp/blah
gcloud auth activate-service-account --key-file /tmp/blah
rm -rf /tmp/blah

gcloud config set project $gcp_proj_id
gcloud config set compute/region $gcp_region


#################### Stop End   ##########################
