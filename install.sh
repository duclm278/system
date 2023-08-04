#!/bin/bash
read -s -p "Password: " tmp
echo "$tmp" | sudo -S apt-get update
echo "$tmp" | sudo -S apt-get install -y python3 python3-pip
pip3 install ansible
PATH=$HOME/.local/bin:$PATH
ansible-playbook -i hosts -e ansible_become_password="$tmp" "$@" local.yml
