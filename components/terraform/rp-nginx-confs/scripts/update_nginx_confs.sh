#!/bin/bash

copy_all=
filename=

copy_file()
{
  sudo aws s3 cp s3://${deployment_s3_bucket}/${s3_key}/$filename /etc/nginx/$filename
}

copy_all()
{
  sudo aws s3 cp s3://${deployment_s3_bucket}/${s3_key}/ /etc/nginx/ --recursive --exclude "*" --include "*.conf"
}

help()
{
  echo "usage:"
  echo "./update_nginx_confs.sh"
  echo "-f | --file  filename : can be multiple times in command line"
  echo ""
  echo "-a | --all            : copies all files with extension conf"
  echo ""
  echo "-h | --help           : this help output"
  echp ""
}

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )   shift
                        filename="$1"
                        copy_file
                        ;;
        -a | --all )    copy_all
                        ;;
        -h | --help )   help
                        exit
                        ;;
        * )             help
                        exit 1
    esac
    shift
done
