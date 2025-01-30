#!/bin/bash
# Use Ansible to create Terraform Backend State S3 Bucket

set -o pipefail

region=${1}
s3_bucket=${2}
deployed_by=${3}
git_repo=${4}

base_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config_dir=$(dirname "${base_dir}")
ansible_location=$(command -v ansible-playbook)

if [[ -z "${ansible_location}" ]]; then
  echo "Ansible must be installed."
else
  echo "${ansible_location}"
fi

ansible-playbook "${config_dir}/ansible/create_tf_s3_backend.yml" \
              --extra-vars "region=${region}" \
              --extra-vars "s3_bucket=${s3_bucket}" \
              --extra-vars "deployed_by=${deployed_by}" \
              --extra-vars "git_repo=${git_repo}"

echo "Finished."