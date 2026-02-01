#!/usr/bin/env bash
# exit on errors
set -euo pipefail

secrets_file="${_repo_dir}/secrets.yaml"
facts_dir="/etc/facter/facts.d"
facts_file="${facts_dir}/arch_install.yaml"

if [[ ! -f "${secrets_file}" ]]; then
  echo "ERROR: ${secrets_file} not found. Copy secrets.yaml.example and fill in values." >&2
  exit 1
fi

# Parse secrets.yaml (simple key: value format)
user_passwd_hash=""
guest_passwd_hash=""
while IFS=': ' read -r key value; do
  value="${value#\"}"
  value="${value%\"}"
  case "${key}" in
    user_passwd_hash)  user_passwd_hash="${value}" ;;
    guest_passwd_hash) guest_passwd_hash="${value}" ;;
  esac
done < "${secrets_file}"

if [[ -z "${user_passwd_hash}" || -z "${guest_passwd_hash}" ]]; then
  echo "ERROR: secrets.yaml must define user_passwd_hash and guest_passwd_hash" >&2
  exit 1
fi

mkdir -p "${facts_dir}"

cat > "${facts_file}" <<EOF
arch_user: ${PUPPET_USER}
arch_user_fullname: ${PUPPET_USER_FULLNAME}
arch_user_uid: ${PUPPET_USER_UID}
arch_guest_user: ${PUPPET_GUEST_USER}
arch_guest_uid: ${PUPPET_GUEST_UID}
arch_hostname: ${INSTALL_HOSTNAME}
arch_user_passwd_hash: "${user_passwd_hash}"
arch_guest_passwd_hash: "${guest_passwd_hash}"
EOF

echo ":: Facter external facts written to ${facts_file}"
