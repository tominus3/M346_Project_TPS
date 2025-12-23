#!/bin/bash
 
# Script:	init.sh
# Description:	Führt alle Skripts aus
# Author:	Paulo Capelos
# Date:		21.12.2025
# Source: 	-

export AWS_DEFAULT_REGION="us-east-1"

# 1. Benutzerinteraktion
 echo "Bitte gib eine Bezeichnung, welche am ende des Buckets hinzugefügt wird"
 echo "Beispiel: output-bucket-m346-project-[Ihre Eingabe]" 

read INPUT

# 2. Eingabeprüfung
if [ -z "$INPUT" ]; then
    echo "Kein Name eingegeben. Abbruch."
    exit 1
fi

# 3. Datenaufbereitung
UNIQUE_BUCKET_NAME=${INPUT,,}
  
INPUT_BUCKET_NAME="input-bucket-m346-project-${UNIQUE_BUCKET_NAME}"
OUTPUT_BUCKET_NAME="output-bucket-m346-project-${UNIQUE_BUCKET_NAME}"  

# 4. Die echten Namen in eine Datei schreiben
echo "INPUT_BUCKET_NAME=$INPUT_BUCKET_NAME" > BucketNames
echo "OUTPUT_BUCKET_NAME=$OUTPUT_BUCKET_NAME" >> BucketNames
 
# 5. Schritt für Schritt Aufruf
echo "-------------------------------------"
  
./Additional/CreateInputBucket.sh

echo "-------------------------------------"
 
./Additional/CreateOutputBucket.sh

echo "-------------------------------------"

./Additional/CreateLambdaFunction.sh

echo "-------------------------------------"
 
./Additional/CreateS3Trigger.sh


