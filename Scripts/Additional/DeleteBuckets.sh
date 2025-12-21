#!/bin/bash

# Script:       DeleteBuckets.sh
# Description:  Skript um die Buckets zu löschen
# Author:       Paulo Capelos
# Date:         10.12.2025

 echo "Welcher Suffix haben die zu löschende Buckets?" 

read INPUT

if [ -z "$INPUT" ]; then
    echo "Kein Suffix eingegeben. Abbruch."
    exit 1
fi

UNIQUE_BUCKET_NAME=${INPUT,,}
  
INPUT_BUCKET="input-bucket-m346-project-${UNIQUE_BUCKET_NAME}"
OUTPUT_BUCKET="output-bucket-m346-project-${UNIQUE_BUCKET_NAME}"

aws s3 rb s3://$INPUT_BUCKET --force
echo "Input Bucket gelöscht"

echo "-------------------------------------"

aws s3 rb s3://$OUTPUT_BUCKET --force
echo "Output Bucket gelöscht"
