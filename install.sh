#!/bin/sh
sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install ansible
ansible-playbook -i hosts -K "$@" site.yml
