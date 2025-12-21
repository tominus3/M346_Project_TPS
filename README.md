## Projektdokumentation: Face Recognition Service

| Übersicht               | Inhalt                                          |
| :---------------------- | :---------------------------------------------- |
| **Modul**               | M346: Cloudlösungen konzipieren und realisieren |
| **Team**                | Paulo Capelos, Tom Nielsen, Sai Ragavan         |
| **Abgabedatum Projekt** | Dienstag, 23. Dezember 2025, 23:59 Uhr          |
| **Repository Link**     | https://github.com/tominus3/M346_Project_TPS    |
| **Lehrperson**          | Martin Früh (frm1971)                           |

## 1. Installation und Setup

### 1.1. Voraussetzungen

- Ein AWS-Konto mit den erforderlichen Berechtigungen zum Erstellen und Verwalten von S3-Buckets und Lambda-Funktionen.

- AWS CLI installiert und konfiguriert auf Ihrem lokalen Rechner.d

### 1.2. Einrichtung des Services

1. Klonen Sie das Repository:
   ```bash
   git clone https://github.com/tominus3/M346_Project_TPS.git
   ```
2. AWS Credentials konfigurieren:
   Navigieren Sie sich zu ihren AWS Academy Learners Lab und kopieren sie die Credentials, welche sie unter: Launch AWS Academy Learners Lab -> AWS Details finden, indem sie auf "Show AWS Credentials" klicken. Diese geben sie in in ihrem Laufwerk unter `.aws/credentials` ein.

3. Service Initialisierung:
   Als erstes muss der Service initialisiert werden. Vergewissern sie sich, dass sie sich im Verzeichnis "Scripts" befinden und führen sie anschliessend den folgenden Befehl aus:

   ```bash
   ./Init.sh
   ```

   Darauf hin müssen sie einen Namen für ihr S3 In-Bucket und S3 Out-Bucket angeben.

4. Bilddaten hochladen:
   Laden sie das Bild, welches sie analysieren möchten, im Verzeichnis "Test" hoch. vergiwssen sie Sich, dass das Bild im JPG-Format vorliegt.

5. Service Ausführung:
   Führen sie anschliessend im gleichen Verzeichnis den folgenden Befehl aus, um den Service zu starten:

   ```bash
   ./test.sh <Bildname>.jpg
   ```

6. Löschen der Ressourcen:
   Um die erstellten Buckets zu löschen, führen sie im Verzeichnis "Scripts" den folgenden Befehl aus:

   ```bash
   ./Reset.sh
   ```

## 2. Service-Architektur und -Implementierung

### 2.1. Aufbau des Cloud Service

Der Face Recognition Service wurde als serverlose Architektur im AWS Learner Lab konzipiert und implementiert. Er basiert auf einem ereignisgesteuerten Modell, das durch das Hochladen einer Datei ausgelöst wird, um die automatische Erkennung bekannter Persönlichkeiten zu gewährleisten.

### 2.2. Funktionsweise des Services

#### 2.2.1. AWS S3 In-Bucket

Das **S3 In-Bucket** (`input-bucket-m346-project`) dient als Eingangsschnittstelle. (Zu ergänzen)

#### 2.2.2. AWS S3 Out-Bucket

Das **S3 Out-Bucket** (`output-bucket-m346-project`) dient als Ausgangsschnittstelle. (Zu ergänzen)

#### 2.2.3. AWS Lambda Funktion

Die Lambda-Funktion ist das zentrale Element und führt die Gesichtserkennung durch.

#### 2.2.4. Berechtigungen und Rollen

## 3. Bedienungsanleitung

## 4. Testfälle und Protokollierung

AWS S3 In-Bucket Testfälle:

AWS S3 Out-Bucket Testfälle:

AWS Lambda Funktion Testfälle:

## 5. Reflexion
