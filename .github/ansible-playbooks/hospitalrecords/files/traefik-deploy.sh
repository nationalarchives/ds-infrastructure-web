#!/bin/bash

help()
{
  echo "usage:"
  echo "./traefik-deploy.sh"
  echo "-u | --up       : traefik container up"
  echo ""
  echo "-d | --down     : traefik container down"
  echo ""
  echo "-r | --restart  : traefik container restart"
  echo ""
  echo "-h | --help           : this help output"
  echo ""

}
up()
{
  sudo docker-compose --project-name=traefik --file /var/docker/compose.traefik.yml up --detach
}

down()
{
  sudo docker-compose --project-name=traefik --file /var/docker/compose.traefik.yml down
}

restart()
{
  sudo docker-compose --project-name=traefik --file /var/docker/compose.traefik.yml restart
}

while [ "$1" != "" ]; do
    case $1 in
        -u | --up )       up
                          ;;
        -d | --down )     down
                          ;;
        -r | --restart )  restart
                          ;;
        -h | --help )     help
                          exit
                          ;;
        * )               help
                          exit
    esac
    shift
done
