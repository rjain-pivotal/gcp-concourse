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
  BOSH_INSTANCE_CMD="gcloud compute instances list --flatten tags.items[] --format json | jq '.[] | select ((.tags.items == \"$gcp_terraform_prefix\" ) and (.metadata.items[].value == \"bosh\" and .metadata.items[].key == \"job\" )) | .name' | tr -d '\"' | sort -u"
  for i in $(eval $BOSH_INSTANCE_CMD);do
    echo "Stopping Instance:$i ..."
    gcloud compute instances stop $i --zone $y

  echo "----------------------------------------------------------------------------------------------"
  echo "Removed or Non Existant bosh instance(s)...."
  echo "----------------------------------------------------------------------------------------------"

  MY_CMD="gcloud compute instances list --flatten tags.items[] --format json | jq '.[] | select ((.tags.items == \"$gcp_terraform_prefix\" ) and (.zone == \"$y\")) | .name' | tr -d '\"'"
  echo $MY_CMD
  gcp_instances=""
  for i in $(eval $MY_CMD); do
  	 gcp_instances="$gcp_instances $i"
  done

  if [ -n "$gcp_instances" ]; then
      echo "|||Stopping Tagged Instances:$gcp_instances"
      echo "|||from zone $y ..."
      gcloud compute instances stop $gcp_instances --zone $y
  fi

  MY_CMD="gcloud compute instances list | grep $gcp_terraform_prefix | grep $y | awk '{print\$1}'"
  echo $MY_CMD
  gcp_instances=""
  for i in $(eval $MY_CMD); do
     gcp_instances="$gcp_instances $i"
  done

  if [ -n "$gcp_instances" ]; then
      echo "|||Stopping Matching Prefix Instances:$gcp_instances"
      echo "|||from zone $y ..."
      gcloud compute instances stop $gcp_instances --zone $y
  fi


	echo "=============================================================================================="
  echo "All compute/instances with the prefix or tag:$gcp_terraform_prefix in zone=$y have been stopped !!!"
	echo "=============================================================================================="
done

#################### Stop End   ##########################
