#!/bin/bash
set -e

# Script:	CreateInputBucket.sh
# Description:	Erstellt ein konfiguriertes Input Bucket
# Author:	Paulo Capelos
# Date:		17.12.2025


if [ -f "BucketNames" ]; then
    source BucketNames
else
    echo "FEHLER: Datei 'BucketNames' nicht gefunden. Bitte zuerst init.sh ausführen."
    exit 1
fi
REGION="us-east-1"

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket $INPUT_BUCKET_NAME Bucket already exists"
else
    echo "Create bucket"
    aws s3 mb s3://$INPUT_BUCKET_NAME --region $REGION
fi

function configure_bucket()
{
	aws s3api put-public-access-block \
	--bucket $INPUT_BUCKET_NAME \
	--public-access-block-configuration "BlockPublicPolicy=false"
}

function activate_ACL()
{
	aws s3api put-bucket-ownership-controls \
	--bucket $INPUT_BUCKET_NAME \
	--ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
}

configure_bucket

echo "Bucket configured"

activate_ACL

echo "Creation input bucket completed"
