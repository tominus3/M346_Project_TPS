#!/bin/bash

# Script:	Reset.sh
# Description:	Löscht die Lambda Funktion und die beiden Buckets
# Author:	Tom Nielsen
# Date:		20.12.2025

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi
export AWS_DEFAULT_REGION="us-east-1"

FUNCTION_NAME="FaceRecognitionLambda"

echo "=== Vollständiger Projekt-Reset ==="

# 1. Lambda-Funktion löschen
echo "Lösche Lambda-Funktion: $FUNCTION_NAME..."
aws lambda delete-function --function-name "$FUNCTION_NAME" >/dev/null 2>&1 || echo "Lambda bereits gelöscht."

# 2. In-Bucket löschen
echo "Lösche In-Bucket: $IN_BUCKET..."
if aws s3 ls "s3://$INPUT_BUCKET_NAME" 2>/dev/null; then
    aws s3 rb "s3://$INPUT_BUCKET_NAME" --force
    echo "$INPUT_BUCKET_NAME erfolgreich gelöscht."
else
    echo "$INPUT_BUCKET_NAME existiert nicht."
fi

# 3. Out-Bucket löschen 
echo "Lösche Out-Bucket: $OUTPUT_BUCKET_NAME..."
if aws s3 ls "s3://$OUTPUT_BUCKET_NAME" 2>/dev/null; then
    aws s3 rb "s3://$OUTPUT_BUCKET_NAME" --force
    echo "$OUTPUT_BUCKET_NAME erfolgreich gelöscht."
else
    echo "$OUTPUT_BUCKET_NAME existiert nicht."
fi

echo "=== Alles wurde gelöscht ==="
