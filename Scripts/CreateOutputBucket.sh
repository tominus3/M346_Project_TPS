#!/bin/bash

# Script:	CreateOutputBucket.sh
# Description:	Erstellt ein konfiguriertes Output Bucket
# Author:	Paulo Capelos
# Date:		17.12.2025

BUCKET_NAME=output-bucket-m346-project

aws s3 mb s3://$BUCKET_NAME

echo "Bucket created"

function configure_bucket()
{
	aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicPolicy=false"
}

function activate_ACL()
{
	aws s3api put-bucket-ownership-controls --bucket $BUCKET_NAME --ownership-controls="Rules=[{ObjectOwnership=BucketOwnerPreferred}]"
}

configure_bucket

echo "Bucket configured"

activate_ACL

echo "Creation output bucket completed"
