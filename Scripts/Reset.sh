#!/bin/bash

# Script:	Reset.sh
# Description:	Löscht die Lambda Funktion und die beiden Buckets
# Author:	Tom Nielsen
# Date:		20.12.2025

# --- KONFIGURATION ---
FUNCTION_NAME="FaceRecognitionLambda"
IN_BUCKET="input-bucket-m346-project67"
OUT_BUCKET="output-bucket-m346-project67"

echo "=== Vollständiger Projekt-Cleanup gestartet ==="

# 1. Lambda-Funktion löschen
echo "Lösche Lambda-Funktion: $FUNCTION_NAME..."
aws lambda delete-function --function-name "$FUNCTION_NAME" 2>/dev/null || echo "-> Lambda bereits gelöscht."

# 2. In-Bucket löschen
echo "Lösche In-Bucket: $IN_BUCKET..."
if aws s3 ls "s3://$IN_BUCKET" 2>/dev/null; then
    aws s3 rb "s3://$IN_BUCKET" --force
    echo "-> $IN_BUCKET erfolgreich gelöscht."
else
    echo "-> $IN_BUCKET existiert nicht."
fi

# 3. Out-Bucket löschen 
echo "Lösche Out-Bucket: $OUT_BUCKET..."
if aws s3 ls "s3://$OUT_BUCKET" 2>/dev/null; then
    aws s3 rb "s3://$OUT_BUCKET" --force
    echo "-> $OUT_BUCKET erfolgreich gelöscht."
else
    echo "-> $OUT_BUCKET existiert nicht."
fi

echo "=== Cleanup abgeschlossen: Alle Ressourcen wurden entfernt! ==="
