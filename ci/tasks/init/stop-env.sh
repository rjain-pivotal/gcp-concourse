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


# stop all GCP Instances for given prefix within Zone ##MG Todo: Serial processing is slow,  look for a quicker way to stop Instances
declare -a ZONE=(
$gcp_zone_1
$gcp_zone_2
$gcp_zone_3
)

for y in ${ZONE[@]}; do
	echo "----------------------------------------------------------------------------------------------"
  echo "Will stop all compute/instances objects with the prefix=$gcp_terraform_prefix in:"
	echo "project=$gcp_proj_id"
	echo "region=$gcp_region"
	echo "zone=$y"
	echo "----------------------------------------------------------------------------------------------"
  echo "Looking for bosh instance(s) first ...."
  echo "----------------------------------------------------------------------------------------------"

done

#################### Stop End   ##########################
