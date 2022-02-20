#!/bin/bash
# Script that installs ansible then runs the ansible playbook on the local host
set -e

# colour outputs
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


if [[ "$EUID" -ne 0 ]]; then
  printf "${RED}> Must be run as root${NC}\n"
  exit 1
fi

read -p "This script will install several packages on your machine, do you want to proceed? [y/N]" choice
case "$choice" in
  y|Y)
    echo "> Setting up host..."
    ;;
  *)
    printf "${RED}> Script cancelled, exiting now${NC}\n"
    exit 0
    ;;
esac

## Install ansible and git
printf "${GREEN}> Installing ansible and git...${NC}\n"
apt update
apt install --yes software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible git

## Clone repo locally
if [[ ! -d ./dev-setup ]]; then
    printf "${GREEN}> Cloning repo...${NC}\n"
    git clone https://github.com/sebvautour/dev-setup.git
    cd dev-setup
else
    printf "${GREEN}> Repo already exists, pulling repo...${NC}\n"
    cd dev-setup
    git config pull.rebase false
    git pull
fi

## Run ansible playbook
printf "${GREEN}> Running play.yml playbook...${NC}\n"
ansible-playbook play.yml

printf "${GREEN}> Done!${NC}\n"
