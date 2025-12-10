#!/bin/bash

# Script:       DeleteBuckets.sh
# Description:  Skript um die Buckets zu löschen
# Author:       Paulo Capelos
# Date:         10.12.2025

aws s3 rb s3://input-bucket-m346-project --force
