#!/bin/bash

# Script:	CreateS3Trigger.sh
# Description:	Teilt einem Bucket den S3 Trigger zu
# Author:	Tom Nielsen
# Date:		17.12.2025

# --- KONFIGURATION ---
IN_BUCKET="input-bucket-m346-project67"
FUNCTION_NAME="FaceRecognitionLambda"

echo "=== S3-Trigger Konfiguration wird gestartet ==="

# 1. Lambda ARN abrufen
# Es ist sicherer, die ARN direkt von AWS zu holen, anstatt sie hart zu codieren.
echo "Hole ARN für Lambda-Funktion: $FUNCTION_NAME..."
FUNCTION_ARN=$(aws lambda get-function --function-name "$FUNCTION_NAME" --query 'Configuration.FunctionArn' --output text)

# 2. Berechtigung für S3 hinzufügen
# S3 benötigt eine explizite Erlaubnis, um die Lambda-Funktion aufrufen zu dürfen.
# Wir hängen einen Zeitstempel an die Statement-ID, um Konflikte bei Wiederholungen zu vermeiden.
echo "Erteile S3 die Berechtigung, die Lambda-Funktion aufzurufen..."
STATEMENT_ID="s3-access-$(date +%s)"

aws lambda add-permission \
  --function-name "$FUNCTION_NAME" \
  --statement-id "$STATEMENT_ID" \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn "arn:aws:s3:::$IN_BUCKET" >/dev/null

# 3. Wartezeit
# AWS benötigt oft einen Moment, bis die neue Policy global verfügbar ist. 
echo "Warte 3 Sekunden, damit die Berechtigungen aktiv werden..."
sleep 3

# 4. S3-Trigger erstellen
# Hier wird S3 angewiesen: 'Wenn ein Objekt erstellt wurde, starte diese Lambda'.
echo "Konfiguriere S3-Event-Notification für Bucket: $IN_BUCKET..."
NOTIFICATION_CONF="{
  \"LambdaFunctionConfigurations\": [
    {
      \"LambdaFunctionArn\": \"$FUNCTION_ARN\",
      \"Events\": [\"s3:ObjectCreated:*\"]
    }
  ]
}"

aws s3api put-bucket-notification-configuration \
  --bucket "$IN_BUCKET" \
  --notification-configuration "$NOTIFICATION_CONF"

echo "=== Erfolg: S3-Trigger für $FUNCTION_NAME wurde aktiviert! ==="
