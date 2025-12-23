#!/bin/bash
set -e

# Script:        test.sh
# Beschreibung:  Automatisiert den Test-Flow: Upload -> Lambda-Trigger -> Output
# Autor:         Sai Ragavan, Tom Nielsen
# Datum:         20.12.2025
# Sources:      AWS Dokumentation, Unterrichtsmaterialien, Gemini

# --- KONFIGURATION ---
CONFIG_FILE="../BucketNames"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"

else
    echo "Bitte führen Sie zuerst die init.sh aus, um die Namen festzulegen."
    exit 1
fi
# 1. Prüfen ob das Argument eine Bilddatei ist
if [ -z "$1" ]; then
    echo "Bitte geben Sie ein Bild als Argument an."
    echo "Verwendung: ./test.sh <dateiname.jpg>"
    exit 1
fi

IMAGE_PATH=$1
FILE_NAME=$(basename "$IMAGE_PATH")
EXPECTED_JSON="${FILE_NAME}.json"

# 2. Bild ins Input-Bucket hochladen
echo "Bild-Upload"
echo "Kopiere $FILE_NAME in den Input-Bucket: $INPUT_BUCKET_NAME"

aws s3 cp "$IMAGE_PATH" "s3://$INPUT_BUCKET_NAME/$FILE_NAME"

echo -e "\n=== Warten auf Ergebnis ==="

# Da Lambda asynchron arbeitet, müssen wir in einer Schleife prüfen,
# wann die Ergebnis-Datei im Output-Bucket erscheint.
MAX_ATTEMPTS=15
COUNT=0

while [ $COUNT -lt $MAX_ATTEMPTS ]; do
    echo -n "." 
    
    # Prüfen ob die Ergebnis-Datei existiert
    if aws s3 ls "s3://$OUTPUT_BUCKET_NAME/$EXPECTED_JSON" > /dev/null 2>&1; then
        echo -e "\n\nAnalyse-Ergebnis wurde erstellt"

        echo "Lade Ergebnis-Datei lokal herunter..."
        aws s3 cp "s3://$OUTPUT_BUCKET_NAME/$EXPECTED_JSON" "./$EXPECTED_JSON"

        echo "----------------------------------------------------"
        echo "DATEI: s3://$OUTPUT_BUCKET_NAME/$EXPECTED_JSON"
        echo "----------------------------------------------------"
        echo "Erkannte Personen:"
        
        grep -oP '"Name":\s*"\K[^"]+' "./$EXPECTED_JSON"
        
        echo -e "\n----------------------------------------------------"
        exit 0
    fi
    
    sleep 2
    COUNT=$((COUNT+1))
done

# 3. Fehler falls kein Ergebnis gefunden wurde
echo -e "\n\n Nach $(($MAX_ATTEMPTS * 2)) Sekunden wurde kein Ergebnis gefunden."
