#!/bin/bash

SOURCE_DIR="/media"
TMP_DIR="/media/.backup-zips"
S3_BUCKET="s3://${deployment_s3_bucket}/wagtail-content"
LOG_FILE="/var/log/media_backup.log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ZIP_NAME="media-backup-$TIMESTAMP.zip"
ZIP_PATH="$TMP_DIR/$ZIP_NAME"

sudo mkdir -p "$TMP_DIR"
sudo mkdir -p /var/log

# Find all files excluding wagtail-content.zip
UPDATED_FILES=$(find "$SOURCE_DIR" -type f ! -name "wagtail-content.zip")

# Create zip
cd "$SOURCE_DIR"
echo "$UPDATED_FILES" | zip -@ "$ZIP_PATH"

# Check whether the ZIP was created successfully
if [ $? -ne 0 ]; then
    echo "$(date): ERROR: Failed to create backup $ZIP_PATH" | sudo tee -a "$LOG_FILE"
    exit 1
fi

# Upload to S3
if sudo aws s3 cp "$ZIP_PATH" "$S3_BUCKET/$ZIP_NAME"; then
    echo "$(date): Successfully uploaded full backup $ZIP_PATH to $S3_BUCKET/$ZIP_NAME" | sudo tee -a "$LOG_FILE"
    sudo rm -f "$ZIP_PATH"

    echo "$(date): Deleted local backup $ZIP_PATH" | sudo tee -a "$LOG_FILE"
else
    echo "$(date): ERROR: Failed to upload full backup $ZIP_PATH to $S3_BUCKET/$ZIP_NAME" | sudo tee -a "$LOG_FILE"
    exit 1
fi
