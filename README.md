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
- AWS CLI installiert und konfiguriert auf Ihrem lokalen Rechner.
- Git installiert auf Ihrem lokalen Rechner.
- Git-Bash (für Windows-Benutzer empfohlen).

### 1.2. Einrichtung des Services

Folgen sie den untenstehenden Schritten, um den Face Recognition Service einzurichten und auszuführen. Jegliche Befehle sind im Terminal (Git-Bash für Windows-Nutzer) auszuführen.

#### 1.2.1 Klonen Sie das Repository:

```bash
git clone https://github.com/tominus3/M346_Project_TPS.git
```

#### 1.2.2 AWS Credentials konfigurieren:

Navigieren Sie sich zu ihren AWS Academy Learners Lab und kopieren sie die Credentials, welche sie unter: Launch AWS Academy Learners Lab -> AWS Details finden, indem sie auf "Show AWS Credentials" klicken. Kopieren sie anschliessend den Inhalt.

##### 1.2.2.1 Linux Version

Den Inhalt geben sie in in ihrem Laufwerk unter `.aws/credentials` ein.

Falls sich der Ordner nicht im gegebenem Pfad befindet, können sie diesen erstellen indem sie den folgenden Befehl ausführen:

```bash
aws configure
```

#### 1.2.2.2 Windows Version

Den Inhalt geben sie in in ihrem Laufwerk unter `C:\Users\<Benutzername>\.aws\credentials` ein.

Falls sich der Ordner nicht im gegebenem Pfad befindet, können sie diesen erstellen indem sie den folgenden Befehl ausführen:

```bash
aws configure
```

#### 1.2.3 Service Initialisierung:

Als erstes muss der Service initialisiert werden. Vergewissern sie sich, dass sie sich im Verzeichnis "Scripts" befinden und führen sie anschliessend den folgenden Befehl aus:

```bash
./Init.sh
```

Darauf hin müssen sie einen Namen für ihr S3 In-Bucket und S3 Out-Bucket angeben.

#### 1.2.4 Bilddaten hochladen:

Laden sie das Bild, welches sie analysieren möchten, im Verzeichnis "Test" hoch. vergiwssen sie Sich, dass das Bild im JPG-Format vorliegt.

#### 1.2.5 Service Ausführung:

Führen sie anschliessend im gleichen Verzeichnis den folgenden Befehl aus, um den Service zu starten:

```bash
./test.sh <Bildname>.jpg
```

#### 1.2.6 Löschen der Ressourcen:

Um die erstellten Buckets zu löschen, führen sie im Verzeichnis "Scripts" den folgenden Befehl aus:

```bash
./Reset.sh
```

## 2. Service-Architektur und -Implementierung

In diesem Abschnitt wird die technische Umsetzung des Face Recognition Service erläutert. Der Service basiert auf einer eventgesteuerten Architektur (Serverless), die AWS S3 und AWS Lambda nutzt.

### 2.1 Infrastruktur-Management: S3-Buckets

Die Speicherung der Daten erfolgt in zwei getrennten S3-Buckets, um Eingangsdaten und Analyseergebnisse zu trennen.

- **Erstellung und Konfiguration (`CreateInputBucket.sh` & `CreateOutputBucket.sh`):** Diese Skripte legen die benötigten Buckets in der Region `us-east-1` an. Dabei werden die Public Access Blocks deaktiviert und die Object Ownership auf `BucketOwnerPreferred` gesetzt, um eine korrekte Berechtigungssteuerung via ACLs zu ermöglichen.

- **Bereinigung (`DeleteBuckets.sh`):** Dieses Skript ermöglicht das automatisierte Löschen der Projektressourcen. Es fordert den Benutzer zur Eingabe des Suffixes auf und entfernt beide Buckets inklusive aller enthaltenen Objekte (`--force`).

### 2.2 Logik und Automatisierung: AWS Lambda

Das Herzstück des Services ist die Lambda-Funktion, welche die Bildanalyse steuert.

- **Bereitstellung der Serverless-Funktion (`CreateLambdaFunction.sh`):** Das Skript automatisiert das Deployment der Funktion "FaceRecognitionLambda". Es verwendet die `dotnet8` Runtime und weist der Funktion die notwendige `LabRole` sowie die Handler-Konfiguration zu. Falls die Funktion bereits existiert, wird lediglich der Code über die `LambdaFunction.zip` aktualisiert.
- **Ereignissteuerung und Workflow-Integration (`CreateS3Trigger.sh`):** Um den Prozess zu automatisieren, wird ein S3-Trigger konfiguriert. Das Skript erteilt S3 die `InvokeFunction`-Berechtigung und setzt eine Event-Notification auf den Input-Bucket, die bei jedem `s3:ObjectCreated:*`-Ereignis die Lambda-Funktion auslöst.

### 2.3 Systemarchitektur

![Systemarchitektur](img/Systemarchitektur.png)

## 3. Testen des Services
