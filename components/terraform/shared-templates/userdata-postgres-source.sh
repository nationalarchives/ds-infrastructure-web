#!/bin/bash

# Update yum
sudo yum update -y

# create swap file
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo chmod 0600 /var/swap.1
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

# attach the volume to instance
region=${region}
volumeName=${volumeName}
volume=${volume}
drive=${drive}

instanceid=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
attachedVolume=$(aws ec2 describe-volumes --region $region --filters Name=tag:Name,Values=$volumeName Name=attachment.instance-id,Values=$instanceid --query "Volumes[*].VolumeId" --output text)
if [[ -z "$attachedVolume" ]]; then
  echo "try to mount EBS"
  avzone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
  ebsvolume=$(aws ec2 describe-volumes --region $region --filters Name=tag:Name,Values=$volumeName Name=availability-zone,Values=$avzone --query 'Volumes[*].[VolumeId, State==`available`]' --output text  | grep True | awk '{print $1}' | head -n 1)
  if [[ -z "$ebsvolume" ]]; then
    echo "error: no volume with name $volumeName found"
    #exit 1
  else
    if [ ! -d "/postgres" ]; then
      sudo mkdir /postgres
    fi
    aws ec2 attach-volume --region $region --volume-id $ebsvolume --instance-id $instanceid --device $volume
    for i in {1..5}
    do
      sleep 10
      volumeStatus=$(aws ec2 describe-volumes --region $region --filters Name=tag:Name,Values=$volumeName Name=availability-zone,Values=$avzone --query 'Volumes[*].[State]' --output text)
      if [ "$volumeStatus" == "in-use" ]; then
        echo "$volumeStatus"
        break
      fi
    done
    if [ "$volumeStatus" != "in-use" ]; then
      echo "volume not ready"
      #exit 2
    fi

    fileSystem=$(sudo file -s $drive)
    if [ "$fileSystem" == "$drive: data" ]; then
      sudo mkfs -t xfs $drive
    fi
    sudo mount $drive /postgres
    if [ ! -d "/postgres/data" ]; then
      sudo mkdir /postgres/data
      sudo mkdir /postgres/log
      sudo chown -R postgres:postgres /postgres
      sudo chmod -R 0700 /postgres/data
    fi
  fi
else
  echo "Volume $attachedVolume already attached"
fi
