#!/bin/bash

# Script:       DeleteBuckets.sh
# Description:  Skript um die Buckets zu löschen
# Author:       Paulo Capelos
# Date:         10.12.2025

INPUT_BUCKET=input-bucket-m346-project 
OUTPUT_BUCKET=output-bucket-m346-project 

aws s3 rb s3://$INPUT_BUCKET --force
aws s3 rb s3://$OUTPUT_BUCKET --force
