#!/bin/bash

# Script:	CreateBuckets.sh
# Description:	Erstellt zwei konfigurierte Buckets
# Author:	Paulo Capelos
# Date:		03.12.2025

BUCKET_NAME=input-bucket-m346-project

aws s3 mb s3://$BUCKET_NAME

function configure_bucket()
{
	aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration "BlockPublicPolicy=false"
}

configure_bucket
