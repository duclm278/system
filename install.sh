#!/bin/bash
read -s -p "Password: " tmp
echo "$tmp" | sudo -S apt-get update
echo "$tmp" | sudo -S apt-get install -y python3 python3-pip pipx
echo "$tmp" | sudo -S apt-get install -y ansible ansible-lint
pipx ensurepath
PATH=$HOME/.local/bin:$PATH
ansible-playbook -i hosts -e ansible_become_password="$tmp" "$@" local.yml
