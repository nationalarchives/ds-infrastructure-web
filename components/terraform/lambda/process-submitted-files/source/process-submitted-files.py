import boto3
import os
import time
import json
from urllib.parse import unquote_plus

s3 = boto3.client('s3')

BUCKET = os.environ['BUCKET_NAME']
PLACEHOLDER = os.environ['PLACEHOLDER_IMAGE']

MAX_RETRIES = 3
RETRY_DELAY = 2

GUARDDUTY_TAG = 'GuardDutyMalwareScanStatus'


def lambda_handler(event, context):
    """
    Process files from SQS messages containing S3 events.

    Behaviour:
      - NO_THREATS_FOUND -> move file from submitted/ to root
      - THREATS_FOUND    -> replace file with placeholder, then move to root
      - Missing tag      -> retry up to MAX_RETRIES
      - Other statuses   -> do not move the file
    """

    for record in event.get('Records', []):
        try:
            body = json.loads(record['body'])
            s3_records = body.get('Records', [])

            for s3_rec in s3_records:

                key = unquote_plus(
                    s3_rec['s3']['object']['key']
                )

                print(f"Processing object key: {key}")

                # Only process files under submitted/
                if not key.startswith('submitted/'):
                    print(f"Skipping object outside submitted/: {key}")
                    continue

                scan_status = None

                # ---------------------------------------------------------
                # Wait for the GuardDuty scan status tag
                # ---------------------------------------------------------
                for attempt in range(1, MAX_RETRIES + 1):
                    try:
                        tagging = s3.get_object_tagging(
                            Bucket=BUCKET,
                            Key=key
                        )

                        tags = {
                            tag['Key']: tag['Value']
                            for tag in tagging.get('TagSet', [])
                        }

                        print(f"Tags for {key}: {tags}")

                        scan_status = tags.get(GUARDDUTY_TAG)

                        # GuardDuty tag is not available yet
                        if not scan_status:

                            if attempt < MAX_RETRIES:
                                print(
                                    f"GuardDuty scan status not available "
                                    f"for {key}. "
                                    f"Retrying {attempt}/{MAX_RETRIES} "
                                    f"in {RETRY_DELAY} seconds..."
                                )

                                time.sleep(RETRY_DELAY)
                                continue

                            # All attempts exhausted
                            raise RuntimeError(
                                f"GuardDuty scan status not available "
                                f"for {key} after "
                                f"{MAX_RETRIES} attempts."
                            )

                        # GuardDuty tag exists
                        print(
                            f"GuardDuty scan status for {key}: "
                            f"{scan_status}"
                        )

                        break

                    except s3.exceptions.NoSuchKey:

                        if attempt < MAX_RETRIES:
                            print(
                                f"Key {key} not found. "
                                f"Retrying {attempt}/{MAX_RETRIES} "
                                f"in {RETRY_DELAY} seconds..."
                            )

                            time.sleep(RETRY_DELAY)

                        else:
                            raise RuntimeError(
                                f"Key {key} not found after "
                                f"{MAX_RETRIES} attempts."
                            )

                # ---------------------------------------------------------
                # Decide what to do based on GuardDuty result
                # ---------------------------------------------------------

                root_key = key.replace('submitted/', '', 1)

                # CLEAN FILE
                if scan_status == 'NO_THREATS_FOUND':

                    print(
                        f"No threats found for {key}. "
                        f"Moving file to root: {root_key}"
                    )

                    s3.copy_object(
                        Bucket=BUCKET,
                        CopySource={
                            'Bucket': BUCKET,
                            'Key': key
                        },
                        Key=root_key
                    )

                    s3.delete_object(
                        Bucket=BUCKET,
                        Key=key
                    )

                    print(
                        f"Deleted original from submitted/: {key}"
                    )

                # THREAT FOUND
                elif scan_status == 'THREATS_FOUND':

                    print(
                        f"Threat detected for {key}. "
                        f"Replacing file with placeholder."
                    )

                    # Replace submitted file with placeholder
                    s3.copy_object(
                        Bucket=BUCKET,
                        CopySource={
                            'Bucket': BUCKET,
                            'Key': PLACEHOLDER
                        },
                        Key=key
                    )

                    print(
                        f"Placeholder applied to {key}."
                    )

                    # Move placeholder to root
                    s3.copy_object(
                        Bucket=BUCKET,
                        CopySource={
                            'Bucket': BUCKET,
                            'Key': key
                        },
                        Key=root_key
                    )

                    # Remove submitted object
                    s3.delete_object(
                        Bucket=BUCKET,
                        Key=key
                    )

                    print(
                        f"Threat file replaced with placeholder "
                        f"and moved to root: {root_key}"
                    )

                # OTHER GUARDDUTY RESULTS
                elif scan_status in (
                    'UNSUPPORTED',
                    'ACCESS_DENIED',
                    'FAILED'
                ):

                    raise RuntimeError(
                        f"GuardDuty could not confirm that {key} "
                        f"is clean. Scan status: {scan_status}. "
                        f"File will remain in submitted/."
                    )

                # UNKNOWN STATUS
                else:

                    raise RuntimeError(
                        f"Unexpected GuardDuty scan status "
                        f"for {key}: {scan_status}. "
                        f"File will remain in submitted/."
                    )

        except Exception as e:
            print(
                f"Error processing record "
                f"{record.get('messageId')}: {e}"
            )

            raise
