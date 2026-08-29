#!/bin/bash
read -s -p "Password: " _pass
echo "${_pass}" | sudo -S apt-get update
echo "${_pass}" | sudo -S apt-get install -y python3 python3-pip pipx ansible ansible-lint yq
pipx ensurepath
PATH="${HOME}/.local/bin:${PATH}"
# ansible-playbook -i hosts -e ansible_become_password="${_pass}" "$@" local.yml

_src="$(cd "$(dirname "$0")" && pwd)"
_hosts="${_src}/hosts"
_playbook="${_src}/local.yml"
_tmp="$(mktemp "${_src}/local.yml.XXXXXXXXXX")"
trap 'rm -f "${_tmp}"' EXIT
yq -y '
  (
    .[]
    | select(has("roles"))
    | .roles[]
  ) |= (
    select(has("role"))
    | if has("tags") then
        .
      else
        . + {"tags": [.role]}
      end
  )
' "${_playbook}" > "${_tmp}"
ansible-playbook -i "${_hosts}" -e ansible_become_password="${_pass}" "$@" "${_tmp}"
