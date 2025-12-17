#!/bin/bash
set -e

FUNCTION_NAME="FaceRecognitionLambda"
ZIP_FILE="function.zip"
RUNTIME="dotnet8"
HANDLER="Function::FunctionHandler"
ROLE_NAME="FaceRecognitionLambdaRole"

# Rolle automatisch abrufen
ROLE_ARN=$(aws iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)
echo "Verwende Rolle ARN: $ROLE_ARN"

echo "=== Lambda-Funktion erstellen ==="
aws lambda create-function \
  --function-name "$FUNCTION_NAME" \
  --runtime "$RUNTIME" \
  --role "$ROLE_ARN" \
  --handler "$HANDLER" \
  --zip-file "fileb://$ZIP_FILE" >/dev/null || echo "Lambda existiert bereits"

echo "Lambda-Funktion $FUNCTION_NAME erstellt."
