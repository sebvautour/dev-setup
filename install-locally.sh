#!/bin/bash
# Script that installs ansible then runs the ansible playbook on the local host
set -e

if [[ "$EUID" -ne 0 ]]; then
  echo "Must be run as root"
  exit 1
fi

read -p "This script will install several packages on your machine, do you want to proceed? [y/N]" choice
case "$choice" in
  y|Y)
    echo "Setting up host..."
    ;;
  *)
    echo "script cancelled, exiting now"
    exit 0
    ;;
esac

## Install ansible and git
apt update
apt install --yes software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible git

## Clone repo locally
if [[ ! -d ./dev-setup ]]; then
    git clone https://github.com/sebvautour/dev-setup.git
    cd dev-setup
else
    cd dev-setup
    git pull
fi

## Run ansible playbook
ansible-playbook play.yml