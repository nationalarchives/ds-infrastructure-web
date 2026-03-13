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


def lambda_handler(event, context):
    """
    Lambda handler to process files from SQS messages containing S3 events.
    """
    for record in event.get('Records', []):
        try:
            body = json.loads(record['body'])
            s3_records = body.get('Records', [])
            for s3_rec in s3_records:
               
                key = unquote_plus(s3_rec['s3']['object']['key'])
                print(f"Processing object key: {key}")

                if not key.startswith('submitted/'):
                    print(f"Skipping object outside submitted/: {key}")
                    continue

                for attempt in range(1, MAX_RETRIES + 1):
                    try:
                        tagging = s3.get_object_tagging(Bucket=BUCKET, Key=key)
                        tags = {t['Key']: t['Value'] for t in tagging.get('TagSet', [])}
                        print(f"Tags for {key}: {tags}")

                        if tags.get('threat', '').lower() == 'found':
                            print(f"Threat detected for {key}, replacing with placeholder.")
                            s3.copy_object(Bucket=BUCKET,
                                           CopySource={'Bucket': BUCKET, 'Key': PLACEHOLDER},
                                           Key=key)
                        break 
                    except s3.exceptions.NoSuchKey:
                        if attempt < MAX_RETRIES:
                            print(f"Key not found, retrying {attempt}/{MAX_RETRIES}...")
                            time.sleep(RETRY_DELAY)
                        else:
                            print(f"Key {key} not found after {MAX_RETRIES} retries. Skipping.")
                            raise

                root_key = key.replace('submitted/', '', 1)
                print(f"Moving file {key} to root: {root_key}")
                s3.copy_object(Bucket=BUCKET,
                               CopySource={'Bucket': BUCKET, 'Key': key},
                               Key=root_key)
                s3.delete_object(Bucket=BUCKET, Key=key)
                print(f"Deleted original from submitted/: {key}")

        except Exception as e:
            print(f"Error processing record {record.get('messageId')}: {e}")