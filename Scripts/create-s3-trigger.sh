#!/bin/bash
set -e

IN_BUCKET="face-recognition-in-bucket"
FUNCTION_NAME="FaceRecognitionLambda"

# Region und Account dynamisch abrufen
REGION=$(aws configure get region)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
FUNCTION_ARN="arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$FUNCTION_NAME"

echo "=== Lambda-Permission für S3 erstellen ==="
aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id s3invoke \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn "arn:aws:s3:::$IN_BUCKET" || echo "Permission existiert bereits"

echo "=== S3-Trigger erstellen ==="
aws s3api put-bucket-notification-configuration \
  --bucket "$IN_BUCKET" \
  --notification-configuration "{
    \"LambdaFunctionConfigurations\": [
      {
        \"LambdaFunctionArn\": \"$FUNCTION_ARN\",
        \"Events\": [\"s3:ObjectCreated:*\"] 
      }
    ]
  }"

echo "S3-Trigger für $FUNCTION_NAME auf Bucket $IN_BUCKET erstellt."
