Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

sudo touch /var/log/start-up.log

echo "$(date '+%Y-%m-%d %T') - system update" | sudo tee -a /var/log/start-up.log > /dev/null
sudo dnf -y update

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/frontend"

# Fetch parameters from SSM
PARAMS_JSON=$(aws ssm get-parameters-by-path \
    --path "$PARAMETER_PATH" \
    --with-decryption \
    --region "$AWS_REGION" \
    --query "Parameters")

if [ -z "$PARAMS_JSON" ]; then
  echo "Error: No parameters found under the path $PARAMETER_PATH or insufficient permissions."
  exit 1
fi

OUTPUT_FILE="/var/docker/frontend.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 777 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

# Loop over each parameter and handle it correctly
echo "$PARAMS_JSON" | jq -c '.[]' | while read -r PARAMETER; do
    NAME=$(echo "$PARAMETER" | jq -r '.Name | split("/")[-1]')
    VALUE=$(echo "$PARAMETER" | jq -r '.Value')

    # Handle special cases (like docker_images with JSON format)
    if [[ "$NAME" == "docker_images" ]]; then
        # Escape quotes inside docker_images string properly
        ESCAPED_VALUE=$(echo "$VALUE" | sed 's/"/\\"/g')
        echo "Exporting $NAME=\"$ESCAPED_VALUE\""
        export "$NAME"="$ESCAPED_VALUE"
        echo "$NAME=\"$ESCAPED_VALUE\"" >> "$OUTPUT_FILE"
    else
        # For regular variables or variables containing special characters
        if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *":"* ]] || [[ "$VALUE" == *"/"* ]] || [[ "$VALUE" == *"\""* ]]; then
            # Wrap the value in quotes to handle special characters properly
            echo "Exporting $NAME=\"$VALUE\""
            export "$NAME"="$VALUE"
            echo "$NAME=\"$VALUE\"" >> "$OUTPUT_FILE"
        else
            # Normal variable, no need to quote
            echo "Exporting $NAME=$VALUE"
            export "$NAME"="$VALUE"
            echo "$NAME=$VALUE" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Environment variables have been written to $OUTPUT_FILE."

echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh
--//--
