## 📄 Projektdokumentation: Face Recognition Service

| Übersicht               | Inhalt                                          |
| :---------------------- | :---------------------------------------------- |
| **Modul**               | M346: Cloudlösungen konzipieren und realisieren |
| **Team**                | Paulo Capelos, Tom Nielsen, Sai Ragavan         |
| **Abgabedatum Projekt** | Dienstag, 23. Dezember 2025, 23:59 Uhr          |
| **Repository Link**     | https://github.com/tominus3/M346_Project_TPS    |
| **Lehrperson**          | Martin Früh (frm1971)                           |

## 1. Einleitung (README.md)

Dieses Dokument berichtet die Konzeption und Realisierung eines **Face Recognition Service** als Projektarbeit im Rahmen des Moduls 346 (Cloudlösungen konzipieren und realisieren). Das Projekt wurde in einer Dreiergruppe durchgeführt.

**Projektziele:**

1.  **Cloud Service:** Erstellung eines Face Recognition-Service unter Verwendung von AWS S3-Buckets (In- und Out-Bucket) und einer AWS Lambda-Funktion, die durch einen Trigger ausgelöst wird. Die Gesichtserkennung basiert auf dem AWS-Dienst Recognizing celebrities (AWS Rekognition).
2.  **Bereitstellung:** Der Service kann mit allen erforderlichen Komponenten durch Ausführung eines Scripts von einem Windows oder Linux-Client aus im AWS Learner-Lab in Betrieb genommen werden.
3.  **Versionsverwaltung:** Alle für die Inbetriebnahme benötigten Dateien und die zugehörige Dokumentation sind in einem Git-Repository versioniert abgelegt.
4.  **Dokumentation:** Die Dokumentation ist als Markdown geschrieben, mit dem Einstiegspunkt `Readme.md`.
5.  **Test und Protokollierung:** Der Service ist getestet und alle Testfälle sind mittels Screenshots dokumentiert und protokolliert.

### 1.1 Verteilung der Aufgaben

| Komponente              | Aufteilung    |
| :---------------------- | :------------ |
| **AWS S3 In-Bucket**    | Paulo Capelos |
| **AWS S3 Out-Bucket**   | Paulo Capelos |
| **AWS Lambda Funktion** | Tom Nielsen   |
| **Dokumentation**       | Sai Ragavan   |

## 2. Service-Architektur und -Implementierung

### 2.1. Aufbau des Cloud Service

Der Face Recognition Service wurde als serverlose Architektur im AWS Learner Lab konzipiert und implementiert. Er basiert auf einem ereignisgesteuerten Modell, das durch das Hochladen einer Datei ausgelöst wird, um die automatische Erkennung bekannter Persönlichkeiten zu gewährleisten.

### 2.2. Funktionsweise des Services

#### 2.2.1. AWS S3 In-Bucket

Das **S3 In-Bucket** (`input-bucket-m346-project`) dient als **Eingangsschnittstelle**. (Zu ergänzen)

#### 2.2.2. AWS S3 Out-Bucket

Das **S3 Out-Bucket** (`output-bucket-m346-project`) dient als **Ausgangsschnittstelle**. (Zu ergänzen)

#### 2.2.3. AWS Lambda Funktion

Die Lambda-Funktion ist das zentrale Element und führt die Gesichtserkennung durch.

- **Implementierung:** Die Funktion ist in C# implementiert.
- **Auslösung:** (noch einfügen)
- **Aufruf des Dienstes:** (noch einfügen)
