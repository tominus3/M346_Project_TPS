#!/bin/bash

# Script:	CreateLamdaFunction.sh
# Description:	Erstellt die Lambda Funktion
# Author:	Tom Nielsen
# Date:		17.12.2025

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "FEHLER: Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi

FUNCTION_NAME="FaceRecognitionLambda"
ZIP_FILE="LambdaFunction.zip"
HANDLER="CelebrityRecogniser::CelebrityRecogniser.Function::FunctionHandler"
ROLE_ARN="arn:aws:iam::211125635461:role/LabRole"

echo "=== Start: Lambda-Deployment ==="

# 1. Validierung: Existiert die ZIP-Datei wirklich?
if [ ! -f "$ZIP_FILE" ]; then
    echo "FEHLER: Die Datei '$ZIP_FILE' wurde im aktuellen Ordner nicht gefunden!"
    echo "Stelle sicher, dass du im richtigen Verzeichnis bist."
    exit 1
fi

# 2. Infrastruktur-Check: Erstellen oder Aktualisieren
# Wir prüfen mit 'get-function', ob die Lambda bereits existiert.
if aws lambda get-function --function-name "$FUNCTION_NAME" >/dev/null 2>&1; then
    echo "Status: Funktion '$FUNCTION_NAME' existiert bereits. Aktualisiere Code..."
    
    # Aktualisiert nur den Programmcode
    aws lambda update-function-code \
        --function-name "$FUNCTION_NAME" \
        --zip-file "fileb://$ZIP_FILE" >/dev/null
else
    echo "Status: Erstelle neue Funktion '$FUNCTION_NAME'..."
    
    # Erstellt die Funktion komplett neu inkl. aller Parameter
    aws lambda create-function \
        --function-name "$FUNCTION_NAME" \
        --runtime "dotnet8" \
        --role "$ROLE_ARN" \
        --handler "$HANDLER" \
        --zip-file "fileb://$ZIP_FILE" >/dev/null
fi

# 3. Konfigurations-Update
# Wir setzen die Umgebungsvariablen und Ressourcen-Limits separat, 
# damit sie bei jedem Skriptaufruf korrekt gesetzt sind.
aws lambda update-function-configuration \
    --function-name "$FUNCTION_NAME" \
    --environment "Variables={OUT_BUCKET=$OUTPUT_BUCKET_NAME}" \
    --timeout 30 \
    --memory-size 512 >/dev/null

echo "=== ERFOLG: Lambda ist bereit für den Einsatz! ==="
