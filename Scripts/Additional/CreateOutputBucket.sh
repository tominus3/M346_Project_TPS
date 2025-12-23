#!/bin/bash
set -e

# Script:	CreateOutputBucket.sh
# Description:	Erstellt ein konfiguriertes Output Bucket
# Author:	Paulo Capelos
# Date:		17.12.2025
# Source: Unterichtsmaterialien, Gemini

# --- KONFIGURATION ---
if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "FEHLER: Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi

REGION="us-east-1"

# 1. Check and create bucket
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket $OUTPUT_BUCKET_NAME Bucket already exists"
else
    echo "Create bucket"
    aws s3 mb s3://$OUTPUT_BUCKET_NAME --region $REGION
fi

# 2. Configure the safety bar in order to use ACL
function configure_bucket()
{
	aws s3api put-public-access-block \
	--bucket $OUTPUT_BUCKET_NAME \
	--public-access-block-configuration "BlockPublicPolicy=false"
}

# 3. Configure the ownership rights over the buckets
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
