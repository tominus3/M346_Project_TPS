using Amazon.Lambda.Core;
using Amazon.Lambda.S3Events;
using Amazon.Rekognition;
using Amazon.Rekognition.Model;
using Amazon.S3;
using Amazon.S3.Model;
using System.Text.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

// Description: Lambda Funktion zur Erkennung von Prominenten in Bildern mittels AWS Rekognition.
// Author: Tom Nielsen
// Date: 21.12.2025

namespace CelebrityRecogniser;

public class Function
{
    // Clients für die AWS-Dienste.
    private readonly AmazonRekognitionClient _rekognitionClient = new AmazonRekognitionClient();
    private readonly AmazonS3Client _s3Client = new AmazonS3Client();

    /// Der Haupteinstiegspunkt der Lambda-Funktion.
    /// Wird aufgerufen, wenn eine Datei im S3-Input-Bucket landet.
    public async Task FunctionHandler(S3Event evnt, ILambdaContext context)
    {
        // Name des Ziel-Buckets aus der Umgebungsvariable lesen, die wir im Bash-Skript setzen.
        string? outputBucket = Environment.GetEnvironmentVariable("OUT_BUCKET");

        if (string.IsNullOrEmpty(outputBucket))
        {
            context.Logger.LogLine("FEHLER: Die Umgebungsvariable 'OUT_BUCKET' ist nicht gesetzt.");
            return;
        }

        // Wir verarbeiten den ersten Datensatz des Events.
        var s3Record = evnt.Records[0];
        string bucketName = s3Record.S3.Bucket.Name;
        string objectKey = s3Record.S3.Object.Key;

        context.Logger.LogLine($"Starte Analyse für: {bucketName}/{objectKey}");

        try
        {
            // 1. Erstellung der Anfrage an AWS Rekognition.
            // Wir sagen Rekognition, wo das Bild liegt, ohne es selbst herunterladen zu müssen.
            var recognizeRequest = new RecognizeCelebritiesRequest
            {
                Image = new Image
                {
                    S3Object = new Amazon.Rekognition.Model.S3Object
                    {
                        Bucket = bucketName,
                        Name = objectKey
                    }
                }
            };

            // 2. Aufruf der Bildanalyse.
            context.Logger.LogLine("Rufe AWS Rekognition Celebrity Recognition auf...");
            var response = await _rekognitionClient.RecognizeCelebritiesAsync(recognizeRequest);

            // 3. Serialisierung des Ergebnisses in ein schönes JSON-Format.
            string resultJson = JsonSerializer.Serialize(response, new JsonSerializerOptions
            {
                WriteIndented = true
            });

            // 4. Speichern des Ergebnisses im Output-Bucket.
            string resultKey = $"{objectKey}.json";

            context.Logger.LogLine($"Speichere Analyse-Ergebnis unter: {outputBucket}/{resultKey}");

            await _s3Client.PutObjectAsync(new PutObjectRequest
            {
                BucketName = outputBucket,
                Key = resultKey,
                ContentBody = resultJson,
                ContentType = "application/json"
            });

            context.Logger.LogLine("Verarbeitung erfolgreich abgeschlossen.");
        }
        catch (Exception ex)
        {
            // Detailliertes Error-Logging für CloudWatch Logs.
            context.Logger.LogLine($"KRITISCHER FEHLER bei der Verarbeitung von {objectKey}: {ex.Message}");
            context.Logger.LogLine(ex.StackTrace);
            throw;
        }
    }
}