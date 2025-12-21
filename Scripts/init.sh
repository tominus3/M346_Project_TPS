#!/bin/bash
 
# Script:	init.sh
# Description:	Führt alle Skripts aus
# Author:	Paulo Capelos
# Date:		21.12.2025
  
 echo "Bitte gib eine Bezeichnung, welche am ende des Buckets hinzugefügt wird"
 echo "Beispiel: output-bucket-m346-project-jeff" 

read INPUT

if [ -z "$INPUT" ]; then
    echo "Kein Name eingegeben. Abbruch."
    exit 1
fi

UNIQUE_BUCKET_NAME=${INPUT,,}
  
export INPUT_BUCKET_NAME="input-bucket-m346-project-${UNIQUE_BUCKET_NAME}"
export OUTPUT_BUCKET_NAME="output-bucket-m346-project-${UNIQUE_BUCKET_NAME}"  
  
./CreateInputBucket.sh

echo "-------------------------------------"
 
./CreateOutputBucket.sh

echo "-------------------------------------"

./CreateLambdaFunction.sh

echo "-------------------------------------"
 
./CreateS3Trigger.sh


