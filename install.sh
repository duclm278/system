#!/bin/bash
read -s -p "Password: " _pass
echo "${_pass}" | sudo -S apt-get update
echo "${_pass}" | sudo -S apt-get install -y python3 python3-pip pipx ansible ansible-lint yq
pipx ensurepath
PATH="${HOME}/.local/bin:${PATH}"

_src="$(cd "$(dirname "$0")" && pwd)"
_hosts="${_src}/hosts"
_playbook="${_src}/local.yml"
_tags="${_src}/install-tags.jq"
_tmp="$(mktemp "${_src}/local.yml.XXXXXXXXXX")"
trap 'rm -f "${_tmp}"' EXIT
yq -y -f "${_tags}" "${_playbook}" > "${_tmp}"

# 26.04: https://github.com/ansible/ansible/issues/85837
# ansible-playbook -i "${_hosts}" -e "ansible_become_password=${_pass}" "$@" "${_tmp}"
ansible-playbook -i "${_hosts}" -e "ansible_become_exe=/usr/bin/sudo.ws ansible_become_password=${_pass}" "$@" "${_tmp}"
