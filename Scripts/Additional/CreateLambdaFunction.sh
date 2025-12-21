#!/bin/bash

# Script:	CreateLamdaFunction.sh
# Description:	Erstellt die Lambda Funktion
# Author:	Tom Nielsen
# Date:		17.12.2025
# Sources: Unterrichtsmaterialien, AWS Dokumentation, Gemini

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi

echo "Hole ARN für die LabRole..."
ROLE_ARN=$(aws iam get-role --role-name LabRole --query 'Role.Arn' --output text)

if [ -z "$ROLE_ARN" ] || [ "$ROLE_ARN" == "None" ]; then
    echo "Konnte LabRole ARN nicht finden."
    exit 1
fi

FUNCTION_NAME="FaceRecognitionLambda"
ZIP_FILE="LambdaFunction.zip"
HANDLER="CelebrityRecogniser::CelebrityRecogniser.Function::FunctionHandler"


echo "=== Lambda-Deployment ==="

# 1. Überprüfen ob die zip Datei überhaupt existiert
if [ ! -f "$ZIP_FILE" ]; then
    echo "Die Datei '$ZIP_FILE' wurde nicht gefunden!"
    exit 1
fi

# 2. Überpüfen ob die Lambdafuktion bereits existiert
if aws lambda get-function --function-name "$FUNCTION_NAME" >/dev/null 2>&1; then
    echo "Funktion '$FUNCTION_NAME' existiert bereits."
    echo "Wird aktualisiert..."
    
    # Aktualisiert Lambda funktion
    aws lambda update-function-code \
        --function-name "$FUNCTION_NAME" \
        --zip-file "fileb://$ZIP_FILE" >/dev/null
else
    echo "Erstelle neue Funktion '$FUNCTION_NAME'..."
    
    # Erstellt die Funktion
    aws lambda create-function \
        --function-name "$FUNCTION_NAME" \
        --runtime "dotnet8" \
        --role "$ROLE_ARN" \
        --handler "$HANDLER" \
        --zip-file "fileb://$ZIP_FILE" >/dev/null
fi

# 3. Konfiguration für die Funktion setzen 
aws lambda update-function-configuration \
    --function-name "$FUNCTION_NAME" \
    --environment "Variables={OUT_BUCKET=$OUTPUT_BUCKET_NAME}" \
    --timeout 30 \
    --memory-size 512 >/dev/null

echo "=== Lambda ist bereit ==="
