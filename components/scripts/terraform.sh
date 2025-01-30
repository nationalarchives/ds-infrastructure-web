#!/usr/bin/env bash
# Terraform Wrapper Bash Scripts

tfenv use 1.4.6
export AWS_ACCOUNT="968803923593"
export AWS_DEFAULT_REGION="eu-west-2"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Bash Properties
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

set -o errexit
set -o pipefail
set -o nounset

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Script Helper Functions
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

function consoleout_error() {
  echo "${1}"
  exit 1
}

function print_line {
  echo -e "-------------------------------------------------------------------------------------------"
}

function output_command() {
  echo; print_line
  echo "${1}"
  print_line; echo ""
  echo "${2}" | awk '{ gsub(/ +/, " \\ \n" ); print; }'
  echo; print_line; echo
}

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# User passed parameters
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

environment=${1}
action=${2}
shift 2

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform Paths
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
components_dir=$(dirname "${scripts_dir}")
base_dir=$(dirname "${components_dir}")
base_dir_name=$(basename "${base_dir}")
parent_dir=$(dirname "${components_dir}")
tf_vars="${parent_dir}/var/${environment}/terraform"
tf_dir=${components_dir}/terraform

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

client_abbr=$(cat < "${tf_vars}/environment.tfvars" | grep "client_abbr" | awk -F"=" '{print $2}' | awk -F'"' '{print $2}')
region="eu-west-2"
s3_backend="${client_abbr}-terraform-backend-state-web-${region}-${AWS_ACCOUNT}"
s3_backend_key="${base_dir_name}/${environment}.tfstate"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Check if the environment variables directory exists.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ ! -d "$tf_vars" ]; then
  consoleout_error "Directory $tf_vars does not exist.  Have you use the correct environment: $environment?"
fi

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Export TF_VARS
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

export TF_DATA_DIR="${tf_vars}/.terraform"
export TF_VAR_region=${region}
export TF_VAR_environment=${environment}

# If code is deployed via GitLab
if [ -n "${GITLAB_CI:-}" ]; then
  export TF_VAR_meta_deployed_by="gitlab"
  export TF_VAR_meta_repo_name="${CI_PROJECT_PATH}"
  export TF_VAR_meta_repo_branch="${CI_COMMIT_REF_NAME}"
  export TF_VAR_meta_repo_tag="${CI_COMMIT_REF_NAME:-}"
  export TF_VAR_meta_commit_id="${CI_COMMIT_SHORT_SHA}"
  export TF_VAR_meta_last_commit_author="${GITLAB_USER_NAME}"
  export TF_VAR_meta_build_no="${CI_BUILD_ID}"
# If code is not managed within a git repository (local only)
elif [ -z "$(git config --get remote.origin.url 2>/dev/null)" ]; then
  export TF_VAR_meta_deployed_by="${USER:-unset}"
  export TF_VAR_meta_repo_name="N/A - local"
  export TF_VAR_meta_repo_branch="N/A - local"
  export TF_VAR_meta_repo_tag="N/A - local"
  export TF_VAR_meta_commit_id="N/A - local"
  export TF_VAR_meta_last_commit_author="N/A - local"
  export TF_VAR_meta_build_no="N/A - local"
# If code is managed within a git repository
else
  export TF_VAR_meta_deployed_by=$(git config --global user.name)
  export TF_VAR_meta_repo_name=$(echo "$(basename $(dirname -- $(git config --get remote.origin.url)))/$(basename -s .git $(git config --get remote.origin.url))")
  export TF_VAR_meta_repo_branch=$(git rev-parse --abbrev-ref HEAD)
  export TF_VAR_meta_repo_tag="$(git describe --tags --abbrev=0 $(git rev-parse HEAD) 2> /dev/null)"
  export TF_VAR_meta_commit_id="$(git rev-parse HEAD)"
  export TF_VAR_meta_last_commit_author="$(git log -1 --pretty=format:'%an')"
  export TF_VAR_meta_build_no="N/A"
fi

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Output Terraform variables and working directories
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo -e "\n\n========================================================================\n"
echo "AWS Account: ${AWS_ACCOUNT}"
echo "Environment: ${environment}"
echo "Region":     ${region}
echo "Action:      ${action}"
echo -e "\n========================================================================\n"

echo; print_line
echo "Terraform Components in use:"
print_line
echo; echo "  tf vars:  ${tf_vars}"
echo "terraform:  ${tf_dir}"
echo; print_line; echo

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create S3 bucket backend via ansible if it does not exist
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if ! aws s3api head-bucket --bucket "${s3_backend}" 2>/dev/null; then
  output_command "CREATING S3 BACKEND: ${s3_backend}" "${scripts_dir}/ansible_create_tf_s3_backend.sh"
  ${scripts_dir}/ansible_create_tf_s3_backend.sh ${region} ${s3_backend} ${TF_VAR_meta_deployed_by} ${TF_VAR_meta_repo_name}
fi

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Group all tfvars files together
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

tfvar_files=''

for tfvar_file in "${tf_vars}"/*.tfvars; do
  tfvar_files="${tfvar_files} -var-file=${tfvar_file}";
done

var_file_params="${var_file_params:-} ${tfvar_files}"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform commands
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

tf_init="terraform init \
  -input=false \
  -backend=true \
  -backend-config=\"bucket=${s3_backend}\" \
  -backend-config=\"key=${s3_backend_key}\" \
  -backend-config=\"region=${region}\" \
  \"${tf_dir}/\""

#tf_graph_validate="terraform graph $* -type=validate -draw-cycles \"${tf_dir}\" > ${base_dir}/validate.dot"
tf_validate="terraform validate ${var_file_params} \"${tf_dir}\""
#tf_graph_plan="terraform graph $* -type=plan -draw-cycles \"${tf_dir}\" > ${base_dir}/plan.dot"
tf_plan="terraform plan ${var_file_params} $* -input=false \"${tf_dir}\""
#tf_graph_apply="terraform graph $* -type=apply -draw-cycles \"${tf_dir}\" > ${base_dir}/apply.dot"
tf_apply="terraform apply ${var_file_params} $* -input=false \"${tf_dir}\""
#tf_graph_plan_destroy="terraform graph $* -type=plan-destroy -draw-cycles \"${tf_dir}\" > ${base_dir}/destroy.dot"
tf_destroy="terraform destroy ${var_file_params} $* -input=false \"${tf_dir}\""

combine_tf_action(){
  echo "THIS IS 1 ${1}"
  combined_dir="${parent_dir}/.tf_combined_tmp"
  rm -rf "${combined_dir}"; mkdir "${combined_dir}"
  cp -R "{$tf_dir}" "${combined_dir}"
  cp -R "${tf_vars}" "${combined_dir}"
  cd "${combined_dir}/terraform"
  terraform "${1}"
  cd "${parent_dir}"
  rm -rf "${combined_dir}"
}

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform Init, for fresh environment remove .terraform state file
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [[ "${action}" == "plan" ]]; then
  rm -rf "${TF_DATA_DIR}/terraform.tfstate"
fi

output_command "INITIATING BACKEND:" "${tf_init}"
eval "${tf_init}"

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform Plan
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [[ "${action}" == "plan" ]]; then
  #output_command "TF GRAPH VALIDATE:" "${tf_graph_validate}"
  #eval "${tf_graph_validate}"
  output_command "TF VALIDATE:" "${tf_validate}"
  eval "${tf_validate}"
  #output_command "TF GRAPH PLAN:" "${tf_graph_plan}"
  #eval "${tf_graph_plan}"
  output_command "TF PLAN:" "${tf_plan}"
  eval "${tf_plan}"
fi

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform Apply
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [[ "${action}" == "apply" ]]; then
  #output_command "TF GRAPH APPLY:" "${tf_graph_apply}"
  #eval "${tf_graph_apply}"
  output_command "TF APPLY:" "${tf_apply}"
  eval "${tf_apply}"
fi

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Terraform Destroy
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------

if [[ "${action}" == "destroy" ]]; then
  #output_command "TF GRAPH PLAN-DESTROY:" "${tf_graph_plan_destroy}"
  #eval "${tf_graph_plan_destroy}"
  output_command "TF DESTROY:" "${tf_destroy}"
  eval "${tf_destroy}"
fi
