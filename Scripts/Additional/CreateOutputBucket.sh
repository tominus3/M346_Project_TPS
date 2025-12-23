#!/bin/bash
set -e

# Script:	CreateOutputBucket.sh
# Description:	Erstellt einen  konfigurierten Input Bucket
# Author:	Paulo Capelos
# Date:		17.12.2025
# Source: 	Unterichtsmaterialien, Gemini

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "FEHLER: Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi

REGION="us-east-1"

# 1. Überprüfen und Bucket erstellen
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket $OUTPUT_BUCKET_NAME Bucket already exists"
else
    echo "Create bucket"
    aws s3 mb s3://$OUTPUT_BUCKET_NAME --region $REGION
fi

# 2. Den Sicherheitsriegel konfigurieren, um ACL zu benutzen.
function configure_bucket()
{
	aws s3api put-public-access-block \
	--bucket $OUTPUT_BUCKET_NAME \
	--public-access-block-configuration "BlockPublicPolicy=false"
}

# 3. Die Besitzerrechte über den Bucket konfigurieren
function activate_ACL()
{
	aws s3api put-bucket-ownership-controls \
	--bucket $OUTPUT_BUCKET_NAME \
	--ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
}

configure_bucket

echo "Bucket configured"

activate_ACL

echo "Creation output bucket completed"
