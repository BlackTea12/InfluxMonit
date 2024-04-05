#!/bin/bash
# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
ERROR='\033[1;31;45m'
INFO='\033[1;33;44m'
NC='\033[0m' # No Color


echo -e "$INFO[INFO]$NC checking docker installation"
is_updated=0
if ! command -v docker &> /dev/null; then
  is_updated=1
  echo -e "$BLUE[INSTALL]$NC Docker not found! Installing..."
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

if ! command -v docker-compose &> /dev/null; then
  if [ $is_installed -eq 0 ]; then
    sudo apt-get update
  fi
  echo -e "$BLUE[INSTALL]$NC Docker Compose not found! Installing..."
  sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo -e "\n\n------------------------------\n\n"
docker --version
docker-compose --version
echo -e "\n\n------------------------------\n\n"

echo -e "$INFO[INFO]$NC pulling docker images..."
docker pull telegraf:1.19.3
docker pull grafana/grafana:8.1.2
docker pull influxdb:1.8-alpine

echo -e "$INFO[INFO]$NC docker volume creating..."
mkdir -p ~/.data/grafana
mkdir -p ~/.data/grafana2
mkdir -p ~/.data/influx/config
mkdir -p ~/.data/influxdb
mkdir -p ~/.data/telegraf
docker run --rm telegraf:1.19.3 telegraf config > ~/.data/telegraf/telegraf.conf
docker run --rm --entrypoint /bin/sh grafana/grafana:8.1.2 -c "cat /etc/grafana/grafana.ini" > ~/.data/grafana2/grafana.ini
sudo chown -R 472:472 ~/.data/grafana/

echo -e "$INFO[INFO]$NC docker network creating..."
docker network create --gateway 192.168.2.1 --subnet 192.168.2.0/24 influx-grafana

echo -e "$GREEN'FINISHED!'$NC"