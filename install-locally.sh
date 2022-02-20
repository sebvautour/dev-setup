#!/bin/bash
# Script that installs ansible then runs the ansible playbook on the local host
set -e

if [[ "$EUID" -ne 0 ]]; then
  echo "Must be run as root"
  exit 1
fi


## Install ansible and git
apt update
apt install --yes software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install --yes ansible git-all

## Clone repo locally
git clone https://github.com/sebvautour/dev-setup.git
cd dev-setup

## Run ansible playbook
ansible-playbook play.yml