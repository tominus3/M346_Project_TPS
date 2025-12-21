#!/bin/bash
set -e

# Script:	CreateS3Trigger.sh
# Description:	Teilt einem Bucket den S3 Trigger zu
# Author:	Tom Nielsen
# Date:		17.12.2025
# Source: Unterichtsmaterialien, AWS Dokumentation, Gemini

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi
FUNCTION_NAME="FaceRecognitionLambda"

echo "=== S3-Trigger Konfiguration wird gestartet ==="

# 1. Lambda ARN abrufen
echo "Hole ARN für Lambda-Funktion: $FUNCTION_NAME..."
FUNCTION_ARN=$(aws lambda get-function --function-name "$FUNCTION_NAME" --query 'Configuration.FunctionArn' --output text)

# 2. Berechtigung für S3 hinzufügen 
echo "Erteile S3 die Berechtigung, die Lambda-Funktion aufzurufen..."
STATEMENT_ID="s3-access-$(date +%s)"

aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id "$STATEMENT_ID" \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn "arn:aws:s3:::$INPUT_BUCKET_NAME" >/dev/null

# 3. Wartezeit
echo "Warte 3 Sekunden, damit die Berechtigungen aktiv werden..."
sleep 3

# 4. S3-Trigger erstellen
echo "Konfiguriere S3-Event-Notification für Bucket: $INPUT_BUCKET_NAME..."
NOTIFICATION_CONF="{
  \"LambdaFunctionConfigurations\": [
    {
      \"LambdaFunctionArn\": \"$FUNCTION_ARN\",
      \"Events\": [\"s3:ObjectCreated:*\"]
    }
  ]
}"

aws s3api put-bucket-notification-configuration \
  --bucket "$INPUT_BUCKET_NAME" \
  --notification-configuration "$NOTIFICATION_CONF"

echo "=== S3-Trigger für $FUNCTION_NAME wurde erstellt ==="
