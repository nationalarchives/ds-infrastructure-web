#!/bin/bash
SOURCE_DIR="/media"
TMP_DIR="/media/.backup-zips"
S3_BUCKET="s3://ds-dev-deployment-source/wagtail-content"
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

# Upload to S3
sudo aws s3 cp "$ZIP_PATH" "$S3_BUCKET/$ZIP_NAME"

# Log the operation
echo "$(date): Uploaded full backup $ZIP_PATH to $S3_BUCKET/$ZIP_NAME" | sudo tee -a "$LOG_FILE"

# Clean up
sudo rm -f "$ZIP_PATH"
