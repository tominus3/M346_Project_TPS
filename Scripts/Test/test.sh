#!/bin/bash

# Script:        test.sh
# Beschreibung:  Automatisiert den Test-Flow: Upload -> Lambda-Trigger -> Output
# Autor:         Sai Ragavan, Tom Nielsen
# Datum:         20.12.2025

# --- 1. UMGEBUNG LADEN ---
CONFIG_FILE="../BucketNames"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    
    INPUT_BUCKET=$INPUT_BUCKET_NAME
    OUTPUT_BUCKET=$OUTPUT_BUCKET_NAME
else
    echo "FEHLER: Bitte führen Sie zuerst die init.sh aus, um die Namen festzulegen."
    exit 1
fi
# --- 2. VALIDIERUNG ---
# Sicherstellen, dass das Skript mit einem Bild-Argument aufgerufen wurde.
if [ -z "$1" ]; then
    echo "HINWEIS: Bitte geben Sie ein Bild als Argument an."
    echo "Verwendung: ./test.sh <dateiname.jpg>"
    exit 1
fi

IMAGE_PATH=$1
FILE_NAME=$(basename "$IMAGE_PATH")
EXPECTED_JSON="${FILE_NAME}.json"

# Prüfung, ob die Variablen korrekt aus der init.sh geladen wurden.
if [ -z "$INPUT_BUCKET_NAME" ]; then
    echo "FEHLER: Variable INPUT_BUCKET ist leer. Prüfe die init.sh."
    exit 1
fi

# --- 3. TEST-DURCHLAUF STARTEN ---
echo "--- SCHRITT 1: Bild-Upload ---"
echo "Kopiere $FILE_NAME in den Input-Bucket: $INPUT_BUCKET"

# Upload zum S3-Bucket. Dies löst automatisch das S3-Event aus, das die Lambda startet.
aws s3 cp "$IMAGE_PATH" "s3://$INPUT_BUCKET/$FILE_NAME"

echo -e "\n--- SCHRITT 2: Polling (Warten auf Ergebnis) ---"
echo "Lambda verarbeitet das Bild via Amazon Rekognition..."

# Da Lambda asynchron arbeitet, müssen wir in einer Schleife prüfen,
# wann die Ergebnis-Datei im Output-Bucket erscheint.
MAX_ATTEMPTS=15
COUNT=0

while [ $COUNT -lt $MAX_ATTEMPTS ]; do
    # Fortschrittsanzeige im Terminal
    echo -n "." 
    
    # 'ls' prüft die Existenz der Datei. '2>/dev/null' unterdrückt Fehlermeldungen,
    # solange die Datei noch nicht generiert wurde.
    if aws s3 ls "s3://$OUTPUT_BUCKET/$EXPECTED_JSON" > /dev/null 2>&1; then
        echo -e "\n\nERFOLG: Analyse-Ergebnis wurde erstellt!"
        echo "----------------------------------------------------"
        echo "DATEI: s3://$OUTPUT_BUCKET/$EXPECTED_JSON"
        echo "----------------------------------------------------"
        echo "INHALT DER JSON-ANALYSE:"
        
        # 'cp ... -' lädt die Datei herunter und gibt den Inhalt direkt im Terminal aus.
        aws s3 cp "s3://$OUTPUT_BUCKET/$EXPECTED_JSON" -
        
        echo -e "\n----------------------------------------------------"
        exit 0
    fi
    
    # 2 Sekunden warten vor dem nächsten Versuch, um API-Anfragen zu begrenzen.
    sleep 2
    COUNT=$((COUNT+1))
done

# --- 4. FEHLER ---
echo -e "\n\n TIMEOUT: Nach $(($MAX_ATTEMPTS * 2)) Sekunden wurde kein Ergebnis gefunden."
